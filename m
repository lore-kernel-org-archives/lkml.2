Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab2K2Wxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 17:53:54 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:62415 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab2K2Wxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 17:53:53 -0500
MIME-Version: 1.0
In-Reply-To: <1354229172.1700.18.camel@joe-AO722>
References: <cover.1351135988.git.joe@perches.com> <1351864140.3537.1.camel@joe-AO722>
 <1352760850.18715.8.camel@joe-AO722> <20121112152621.eb14d7f0.akpm@linux-foundation.org>
 <1354226895.1700.12.camel@joe-AO722> <20121129142143.22886573.akpm@linux-foundation.org>
 <1354229172.1700.18.camel@joe-AO722>
From: Kay Sievers <kay@vrfy.org>
Date: Thu, 29 Nov 2012 23:53:32 +0100
Message-ID: <CAPXgP10xdSBT=2onSxwK7tFFJeo0eAtp0ugPWH_tUbxBhFtVHg@mail.gmail.com>
Subject: Re: [PATCH V2 00/23] printk: refactoring
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Jan H." <schnhrr@cs.tu-berlin.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 11:46 PM, Joe Perches <joe@perches.com> wrote:

> It's still a scheduling issue with Kay and Jan's patches.
> Does anyone have any idea if/when those patches are going in?

I was expecting that Jan rebases the patches incorporating
the latest fix. Jan?

It should not hold back anything else that is already ready to merge.
We will manage it to rebase, I think.

Thanks,
Kay
