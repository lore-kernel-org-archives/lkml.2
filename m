Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab0LULT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 06:19:59 -0500
Received: from relay01.mx.bawue.net ([193.7.176.67]:34904 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750805Ab0LULT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 06:19:58 -0500
Date: Tue, 21 Dec 2010 12:19:57 +0100
From: Nils Radtke <lkml@Think-Future.com>
To: Linux Kernel-List <linux-kernel@vger.kernel.org>
Subject: acer travelmate 5220 crashes
Message-ID: <20101221111957.GA8012@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.com>
Mail-Followup-To: Nils Radtke <lkml@Think-Future.com>,
	Linux Kernel-List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

  First off: Thank you all for your work. Lately, running 2.6.37-rc5, 
  the acer travelmate 5220 didn't for the first time crash within 10 days!

  Usually it crashed a couple of times a day. On a variety of kernels. X
  crashed, basically it crashed anything for nothing. Until these days.
  For all the crash logs, dumps and more google for acer 5220 lkml oops ..

  Ok, on day 11 it crashed again (*sniff). And yesterday again. (*sigh) But
  this is nothing compared to what we experienced before the 2.6.37-rc5
  kernel. :)

  Yesterday however, something unusual happened: Using skype we held a 
  phone conference, a couple of participants, nothing particular. Then 
  out of a sudden (well, as always..) we dropped out of warp: X disappeared,
  we were taken back to a console, only to see the last lines of the oops msg
  to vanish at the top of the screen. It said, trying to kill idle task, 
  kernel panic.

  Still while reading the message, we got a plain old telephony call from one
  of the participants, telling us that his notebook crashed. Wow! How that?
  Coincidence? I don't believe in that kind of things.. He had XP running, we 
  were watching our kernel 2.6.37-rc5 dying, both had exclusively running skype, 
  both crashed to pieces.

  I'd say, even with an evil app like skype, this devilish hack should not
  be able to take down the whole system, it seems - iff correlated - to affect
  both, Linux and Windos.

  Other ideas/opinions on this?

  Happy days,

      Nils


