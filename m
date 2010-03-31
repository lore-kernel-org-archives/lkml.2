Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503Ab0CaXjs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 19:39:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54000 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754322Ab0CaXjq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 19:39:46 -0400
Message-ID: <4BB3DC4E.7030504@zytor.com>
Date: Wed, 31 Mar 2010 16:35:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
       linux-kernel@vger.kernel.org, airlied@linux.ie,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: Config NO_BOOTMEM breaks my amd64 box
References: <alpine.LRH.2.00.1003311539490.23281@tundra.namei.org> <4BB2EB1B.8090303@zytor.com> <alpine.LRH.2.00.1003311747040.23859@tundra.namei.org> <20100331185916.GA12306@elte.hu> <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.00.1004010952080.31957@tundra.namei.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2010 03:58 PM, James Morris wrote:
> On Wed, 31 Mar 2010, Ingo Molnar wrote:
> 
>>>
>>> Yes, it was happening with -rc3.
>>
>> Could you please send the bootlog that Yinghai asked for, plus also one that 
>> you get with NO_BOOTMEM turned off (for comparison)?
> 
> I don't have the old boot logs, and have since upgraded the system 
> further.  
> 

Upgraded how?  The problem no longer happens?

> IIRC, the boot was failing after not being able to find the root fs 
> (ext3/lvm/raid0).  I thought it was a dracut issue, but it seemed to be 
> fixed by enabling bootmem.

This would rather match the problem that was addressed by the patch in
-rc3.  Any help in reproducing it would be great.

	-hpa
