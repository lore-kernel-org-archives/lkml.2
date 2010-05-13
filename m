Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758998Ab0EMPVi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 11:21:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56032 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758959Ab0EMPVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 11:21:35 -0400
Date: Thu, 13 May 2010 08:19:22 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Bastien Nocera <hadess@hadess.net>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <alpine.LFD.2.00.1005130751300.3711@i5.linux-foundation.org>
Message-ID: <alpine.LFD.2.00.1005130805150.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net>  <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <1273762051.2308.4671.camel@localhost.localdomain> <alpine.LFD.2.00.1005130751300.3711@i5.linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 13 May 2010, Linus Torvalds wrote:
> 
> On one of my Mac Mini's (didn't check the other), I get this:
> 
> 	[    2.955087] PNP: No PS/2 controller found. Probing ports directly.
> 	[    2.958475] i8042.c: No controller found.
> 	[    2.960998] mice: PS/2 mouse device common for all mice
> 
> what do you get?

Hah. On the other one, I get

	PNP: No PS/2 controller found. Probing ports directly.
	mice: PS/2 mouse device common for all mice

but that works fine too. As mentioned, the controller hardware should all 
be there - whether it's then enabled or not is a firmware issue.

At the same time, I do think our detection is likely pretty dang weak too. 
Do you get any interesting messages if you just enable DEBUG in 
drivers/input/serio/i8042.h?

			Linus
