Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758198Ab0ENSr7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:47:59 -0400
Received: from mail.lang.hm ([64.81.33.126]:37607 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757574Ab0ENSr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:47:57 -0400
Date: Fri, 14 May 2010 11:47:43 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <alpine.LFD.2.00.1005140814380.3711@i5.linux-foundation.org>
Message-ID: <alpine.DEB.2.01.1005141144250.8603@asgard.lang.hm>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100514145539.GA5598@srcf.ucam.org> <alpine.LFD.2.00.1005140814380.3711@i5.linux-foundation.org>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 May 2010, Linus Torvalds wrote:

> On Fri, 14 May 2010, Matthew Garrett wrote:
>>
>> I've done some experimentation under qemu. On ACPI systems, Windows will
>> *only* touch the keyboard controller if there's a device with an
>> appropriate PNP HID or CID and if _STA evaluates to 0x0b or 0x0f.
>> Otherwise it'll simply ignore the hardware entirely. By the looks of it
>> their keyboard probing is also somewhat different to ours, but that's
>> probably another story.
>
> Well, I'd hate to lose the keyboard hotplug capability, but at the same
> time, it _is_ 2010, and while I have personally used it historically, I
> don't really foresee ever using it again.

this is actually fairly common in datacenter environments where people 
plug in crash carts to problem machines.

yes, everything has USB ports, so they could use USB keyboards, but it's 
actually pretty common to still use PS/2 keyboards (and while the systems 
all support USB, it's not uncommon to have KVM systems, including pretty 
expensive 'enterprise' KVM systems that still require PS/2 keyboards be 
used to plug into the KVM, so those are the keyboards that are in the 
datacenter that someone will grab to plug into a problem machine)

David Lang
