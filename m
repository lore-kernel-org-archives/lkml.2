Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab2HVRD6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:03:58 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:35415 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932992Ab2HVRD4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:03:56 -0400
MIME-Version: 1.0
In-Reply-To: <20120822165933.GU7995@opensource.wolfsonmicro.com>
References: <1345615515-26745-1-git-send-email-shubhrajyoti@ti.com>
	<20120822165933.GU7995@opensource.wolfsonmicro.com>
Date: Wed, 22 Aug 2012 22:33:55 +0530
Message-ID: <CAM=Q2cvEyas6r8pb-edQ7UUJOE1YSxns9j5hA8Cz5pJnd4mPYA@mail.gmail.com>
Subject: Re: [PATCHv2 0/3] spi: omap2-mcspi: spi cleanups
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Shubhrajyoti D <shubhrajyoti@ti.com>,
        spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:29 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Wed, Aug 22, 2012 at 11:35:11AM +0530, Shubhrajyoti D wrote:
>> This patch does the following
>>
>> Calls the pm_runtime_* functions directly.
>> Remove the MOD_REG_BIT macro usage thereby removiing un-needed branch.
>> At remove dont use the autosuspend runtime calls.
>
> Applied all, thanks.

thanks.

>
>> The following changes since commit 23dcfa61bac244e1200ff9ad19c6e9144dcb6bb5:
>>
>>   Merge branch 'akpm' (Andrew's patch-bomb) (2012-08-21 17:22:22 -0700)
>
> When sending pull requests please always base them off a tag of some
> kind, normally one of Linus' is a good option if you've no special
> needs.  This one looks like it's based off -next so can't be pulled into
> any other tree, -next is rebased daily.

Actually there was a patch in your tree that I sent which is not yet
in linus tree so I rebased
it to linux-next to avoid any merge conflicts.

Henceforth I will rebase it to your tree.
