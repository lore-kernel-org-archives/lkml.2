Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab0CaW6z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 18:58:55 -0400
Received: from tundra.namei.org ([65.99.196.166]:36609 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758387Ab0CaW6y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 18:58:54 -0400
Date: Thu, 1 Apr 2010 09:58:03 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
In-Reply-To: <20100331185916.GA12306@elte.hu>
Message-ID: <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <20100331185916.GA12306@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Ingo Molnar wrote:

> > 
> > Yes, it was happening with -rc3.
> 
> Could you please send the bootlog that Yinghai asked for, plus also one that 
> you get with NO_BOOTMEM turned off (for comparison)?

I don't have the old boot logs, and have since upgraded the system 
further.  

IIRC, the boot was failing after not being able to find the root fs 
(ext3/lvm/raid0).  I thought it was a dracut issue, but it seemed to be 
fixed by enabling bootmem.

> Also, when did you first hit this bug? This code has been upstream for almost 
> a month, and it was in linux-next before that - so you should have hit this 
> much sooner. A rough timeframe would suffice. I suppose you were booting 
> upstream kernels during the merge window as well?

In this case, in the last few days (also when I first saw or noticed the 
bootmem option).  I was booting relatively recent linus kernels during the 
merge window, although my main work was being done on an older upstream 
kernel.


-- 
James Morris
<jmorris@namei.org>
