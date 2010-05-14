Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0ENPSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 11:18:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57685 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751140Ab0ENPSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 11:18:53 -0400
Date: Fri, 14 May 2010 08:16:34 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <20100514145539.GA5598@srcf.ucam.org>
Message-ID: <alpine.LFD.2.00.1005140814380.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100514145539.GA5598@srcf.ucam.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 May 2010, Matthew Garrett wrote:
>
> I've done some experimentation under qemu. On ACPI systems, Windows will 
> *only* touch the keyboard controller if there's a device with an 
> appropriate PNP HID or CID and if _STA evaluates to 0x0b or 0x0f. 
> Otherwise it'll simply ignore the hardware entirely. By the looks of it 
> their keyboard probing is also somewhat different to ours, but that's 
> probably another story.

Well, I'd hate to lose the keyboard hotplug capability, but at the same 
time, it _is_ 2010, and while I have personally used it historically, I 
don't really foresee ever using it again.

So we _could_ decide to just try it, and see if anybody screams. If nobody 
does, that would be a very simple solution to the problem.

			Linus
