Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1DGJI2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 05:08:28 -0400
Received: from lo.gmane.org ([80.91.229.12]:48398 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832Ab1DGJI0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 05:08:26 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alexander Clouter <alex@digriz.org.uk>
Subject: Re: [PATCH 1/2] ARM: Differentiate SheevaPlugs and DockStars on the basis of the memory size.
Date: Thu, 7 Apr 2011 09:55:25 +0100
Message-ID: <toa078-0do.ln1@chipmunk.wormnet.eu>
References: <1302122121-3652-1-git-send-email-holler@ahsoftware.de> <1302122121-3652-2-git-send-email-holler@ahsoftware.de> <alpine.LFD.2.00.1104061739100.28032@xanadu.home> <4D9CED15.2010806@ahsoftware.de> <alpine.LFD.2.00.1104061850410.28032@xanadu.home> <4D9CF5B3.9020007@ahsoftware.de>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: chipmunk.wormnet.eu
User-Agent: tin/1.9.6-20100522 ("Lochruan") (UNIX) (Linux/2.6.32-5-sparc64-smp (sparc64))
Cc: linux-arm-kernel@lists.infradead.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In gmane.linux.kernel Alexander Holler <holler@ahsoftware.de> wrote:
> 
> Sorry, I don't feel the need to waste my time prodcuing patches to get 
> them called "abominations". Which means my willingness to post further 
> patches just got below zero.
> 
In a posting from Nico before you got offended it was explained to you 
*why* it was a Bad Idea(tm) and that that sort of thing simply does not 
work.  As a game, is it really a situation with *zero* probability of 
occuring that someone might produce a kirkwood/Sheeva flavoured board 
with only 128MB RAM?

As well as a willingness to 'produce' patches (which to be frank 
*anyone* can do[1])...the hard part is producing *good* patches.  To 
produce good patches you need to read and understand the wisdom you get 
back from the mailing lists you post to.  If you do not understand the 
reasoning, ask.

This is why you see [PATCHv${BIGNUM}] so often in a number of mailing 
lists.  If you are not willing to accept *everyone*, including yourself, 
writes crap code...well the value of your patches falls below zero.

Cheers

[1] just look at the abomination Marvell released for their 'orion5x' 
	chipset originally

-- 
Alexander Clouter
.sigmonster says: But Captain -- the engines can't take this much longer!

