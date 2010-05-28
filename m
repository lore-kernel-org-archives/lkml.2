Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab0E1Ocy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 10:32:54 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36836 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750842Ab0E1Ocw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 10:32:52 -0400
Date: Fri, 28 May 2010 07:28:38 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Hutterer <peter.hutterer@who-t.net>
cc: Dave Airlie <airlied@gmail.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Florian Ragwitz <rafl@debian.org>, Arjan Opmeer <arjan@opmeer.net>,
       Eric Piel <eric.piel@tremplin-utc.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 2.6.35-rc0
In-Reply-To: <20100528061957.GA19624@quokka.bne.redhat.com>
Message-ID: <alpine.LFD.2.00.1005280724550.11382@i5.linux-foundation.org>
References: <20100520165243.GA20861@core.coreip.homeip.net> <alpine.LFD.2.00.1005271837050.11382@i5.linux-foundation.org> <AANLkTiklv48cDWNqKlFfh5RVtxxNH8shH_JjDypPgeHA@mail.gmail.com> <alpine.LFD.2.00.1005272108210.11382@i5.linux-foundation.org>
 <AANLkTinPt49coLNjPqJSSxDP8zTmnjbKuIP1NuQFvwL-@mail.gmail.com> <20100528061957.GA19624@quokka.bne.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 28 May 2010, Peter Hutterer wrote:
> 
> Default behaviour is tapping on for no-button touchpads (like the ones on
> the apples) and tapping off for everything else.

It may well be a good default when the buttons are physically separate 
(like on a lot of touchpads). But when the bottom of the touchpad itself 
is the button (ie the touchpad has a rocker, and you have to press down on 
the touchpad itself), the buttons technically _exist_, but they are 
basically useless.

That Dell machine got a lot of bad reviews for its horribe touchpad, and I 
used to not understand why people disliked the touchpad so much - it 
didn't feel horrible to me. But now I wonder if Windows has the same 
logic, and reviewers - like me - hadn't realized to enable the tap 
feature.

			Linus
