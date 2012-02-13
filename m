Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757322Ab2BMWK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 17:10:28 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36516 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755804Ab2BMWK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 17:10:26 -0500
MIME-Version: 1.0
In-Reply-To: <20120213172613.be7258c4c34431ff31dcbbef@canb.auug.org.au>
References: <20120213172613.be7258c4c34431ff31dcbbef@canb.auug.org.au>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 13 Feb 2012 15:10:05 -0700
X-Google-Sender-Auth: Wijr27ILI4K25bRqBWpvHh72u00
Message-ID: <CACxGe6vbtzEg4CUw643EERn_=fu+uHo4S=vk3wySn5=xX3zbQA@mail.gmail.com>
Subject: Re: linux-next: Tree for Feb 13
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 11:26 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> Changes since 20120210:
>
> New trees: iscsi, dma-mapping
>
> The pci tree gained a build failure so I used the version from
> next-20120210.
>
> The target-updates tree lost its build failure.
>
> The gpio tree still has its build failure for which I reverted a commit.

I've pushed out a new tree that restricts the sodaville driver to x86.
 This should no longer be a problem.

g.
