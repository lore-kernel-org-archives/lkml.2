Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622Ab0ETQ2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 12:28:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36888 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751835Ab0ETQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 12:28:48 -0400
Date: Thu, 20 May 2010 09:26:23 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>, Don Prince <dhprince-devel@yahoo.co.uk>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT] HID
In-Reply-To: <alpine.LFD.2.00.1005200912540.23538@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005200922020.23538@i5.linux-foundation.org>
References: <alpine.LNX.2.00.1005191430370.28092@pobox.suse.cz> <alpine.LFD.2.00.1005200912540.23538@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 20 May 2010, Linus Torvalds wrote:
> 
> This is just unbelievable SH*T:
> 
> 	config HID_ZYDACRON
> 		tristate "Zydacron remote control support" if EMBEDDED
> 		depends on USB_HID
> 		default !EMBEDDED
> 		---help---
> 		Support for Zydacron remote control.

Oh, and I notice that I shouldn't blame Don - this kind of crap is 
apparently de rigeur in the HID layer. I only noticed because this time it 
was a clearly very specialized driver and I started wondering what that 
odd name was.

Guys, I can understand it if it's some kind of big-name "exists 
everywhere" thing. Doing it for big vendors like Logitech devices may make 
sense. But don't do it for random specialized hardware. At least ask the 
user "Do you want to support all the HID crap in the universe" to allow 
people to say Yes/No once (instead of for every single crazy device).

			Linus
