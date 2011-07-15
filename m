Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932597Ab1GOAQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 20:16:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41230 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932371Ab1GOAP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 20:15:58 -0400
Message-ID: <4E1F86AE.9090903@zytor.com>
Date: Thu, 14 Jul 2011 17:15:42 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: "John Z. Bohach" <jzb2@aexorsyst.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: large initramfs causes h/w reset after decompressing
References: <201107140906.46404.jzb2@aexorsyst.com> <201107141532.59383.jzb2@aexorsyst.com> <4E1F7B40.6030705@zytor.com> <201107141635.07673.jzb2@aexorsyst.com>
In-Reply-To: <201107141635.07673.jzb2@aexorsyst.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/14/2011 04:35 PM, John Z. Bohach wrote:
>>> But excuse my ignorance, I don't see the relevance of your
>>> question...the initramfs is part of the kernel itself...I simply
>>> load the kernel bzImage (all 890 MB) and that's where its all
>>> at...this is _not_ an initrd.
>>
>> Ah, interesting.  You didn't say that.  That does change some
>> things... I would not at all be surprised if the kernel decompressor
>> doesn't handle that very well...
>>
> 
> Sorry, I thought initramfs would be clear on its own that its not 
> initrd, but I guess some people do use it interchangeably.  Anyway, I 
> have some experience in programming, so is there anything you could 
> suggest that I might tweak to test your theory on the decompressor?  Or 
> would this be more of a kernel VM allocator issue?  Also, would 
> ramdisk_size have any bearing on this?
> 

initramfs can be built in or loaded via the initrd protocol.

Anyway, it's hard to say for sure what to look for, but the first thing
is to try to "fence" the problem... that is, establish the latest point
which is successfully crossed and the earliest point which is not.

	-hpa

