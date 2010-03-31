Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab0CaXoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:44:10 -0400
Received: from tundra.namei.org ([65.99.196.166]:38739 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753472Ab0CaXoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:44:07 -0400
Date: Thu, 1 Apr 2010 10:43:30 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
In-Reply-To: <4BB3DC4E.7030504@zytor.com>
Message-ID: <alpine.LRH.2.00.1004011042460.32618@tundra.namei.org>
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <20100331185916.GA12306@elte.hu> <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
 <4BB3DC4E.7030504@zytor.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, H. Peter Anvin wrote:

> On 03/31/2010 03:58 PM, James Morris wrote:
> > On Wed, 31 Mar 2010, Ingo Molnar wrote:
> > 
> >>>
> >>> Yes, it was happening with -rc3.
> >>
> >> Could you please send the bootlog that Yinghai asked for, plus also one that 
> >> you get with NO_BOOTMEM turned off (for comparison)?
> > 
> > I don't have the old boot logs, and have since upgraded the system 
> > further.  
> > 
> 
> Upgraded how?  The problem no longer happens?

Upgraded to the latest rawhide userland -- I have not since tested with 
bootmem off.  I'll try and do so again when I get a chance.


> 
> > IIRC, the boot was failing after not being able to find the root fs 
> > (ext3/lvm/raid0).  I thought it was a dracut issue, but it seemed to be 
> > fixed by enabling bootmem.
> 
> This would rather match the problem that was addressed by the patch in
> -rc3.  Any help in reproducing it would be great.
> 
> 	-hpa
> 

-- 
James Morris
<jmorris@namei.org>
