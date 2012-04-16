Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab2DPXVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:21:47 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61382 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468Ab2DPXVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:21:46 -0400
MIME-Version: 1.0
In-Reply-To: <1334617419.25353.15.camel@pasglop>
References: <1334607198-18694-1-git-send-email-grant.likely@secretlab.ca>
 <CACxGe6u7EUYqyZ_8tC8PFRHwS+xq7u9+fCJk+UFbrtrV-YJFvQ@mail.gmail.com> <1334617419.25353.15.camel@pasglop>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 16 Apr 2012 17:21:25 -0600
X-Google-Sender-Auth: V71RacNXe5-iPOsRGc-WR0b7w5U
Message-ID: <CACxGe6v3n7tjpMFCzyf+a0dvHm6X6KAcgm-VurVsUfugmKW5Sg@mail.gmail.com>
Subject: Re: [PATCH 1/2] powerpc/8xx: Fix NR_IRQ bugs and refactor 8xx
 interrupt controller
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 5:03 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> On Mon, 2012-04-16 at 14:13 -0600, Grant Likely wrote:
>> Ben, I can take these two patches via my irqdomain tree if you prefer.
>
> Let me give them a test run first.

Yes of course.  I won't merge before they've been checked out.

g.
