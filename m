Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754218Ab1G0JE2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:04:28 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:38069 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484Ab1G0JEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:04:25 -0400
Date: Wed, 27 Jul 2011 11:04:20 +0200
From: Tejun Heo <tj@kernel.org>
To: Shreshtha <shreshthakumar@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Kernel Oops on enabling CONFIG_LOCK_STAT
Message-ID: <20110727090420.GX2622@htj.dyndns.org>
References: <CAKWOLpKFe=rjms5=cvEMJSbiHE0+j+3wK-bGRJWpP1QCJ63Sow@mail.gmail.com>
 <20110722061054.GA2622@htj.dyndns.org>
 <20110722073417.GB2622@htj.dyndns.org>
 <CAKWOLpKkohE4ULRzNHUvPbrViT0Wn++XJ35xkKoGDV_f2ygYSw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKWOLpKkohE4ULRzNHUvPbrViT0Wn++XJ35xkKoGDV_f2ygYSw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 26, 2011 at 06:49:23PM +0530, Shreshtha wrote:
> Hi Tejun Heo,
> 
> Problem persists even after applying the patch.
> After applying the debug patch (and printk for rs,re etc.) related
> output in mail below.
> 
> The log attached was with linux-2.6.35.7 kernel.
> I tried newer kernel i.e. 2.6.39.3 and problem was *not* seen.
> Seems that changes in mm/* solved the issue.
> So I will take this thread from here.

Eh... sure.  percpu was pretty young back then and we've had good
number of bugs fixed since then.  I guess I should have asked kernel
version first.  Anyways, good to hear the problem is already fixed.

-- 
tejun
