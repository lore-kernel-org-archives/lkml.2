Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758771Ab0EMVYD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:24:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32861 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756874Ab0EMVX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:23:59 -0400
Date: Thu, 13 May 2010 14:21:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: lenb@kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <201005131405.45732.dmitry.torokhov@gmail.com>
Message-ID: <alpine.LFD.2.00.1005131410090.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <20100513181002.GB23708@core.coreip.homeip.net> <alpine.LFD.2.00.1005131232350.3711@i5.linux-foundation.org> <201005131405.45732.dmitry.torokhov@gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Dmitry Torokhov wrote:
> 
> But I guess because there are no devices plugged in ACPI they are "inactive" 
> and thus ACPI drop them. I was always wondered by ACPI did that. Len?

Btw, even without actual physically plugging in the device, at least the 
really early KVM boxes used to basically just _physically_ switch between 
keyboard ports, and so using such a KVM switch is essentially also going 
to plug it in after boot time.

Some slightly more fancier KVM devices (probably most of them by now - if 
you want auto-switching etc) have real electronics and actually emulate a 
keyboard, needed for computers that require a keyboard to even boot up 
("Keyboard not detected. Press F1 to continue").

But the hard-switching ones were at least at some point way more reliable: 
the "smart" ones would have trouble with any "fancy" features like 
scroll-wheels etc. Probably not an issue any more.

Of course, these days few people use PS/2 keyboards any more, but it would 
still be a shame to break a perfectly reasonable setup.

			Linus
