Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757861Ab0JVQ3m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 12:29:42 -0400
Received: from mail.wdtv.com ([66.118.69.84]:44281 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757568Ab0JVQ3l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 12:29:41 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re:2.6.36, make oldconfig broken
Date: Fri, 22 Oct 2010 12:29:36 -0400
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.5.2; i686; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010221229.36996.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greets all;

I have managed to get 2.6.36 to a semi-usable state, but I have major 
breakage yet.

Question: what happens if I simply move my working 2.6.35.7 .config into the 
2.6.36 tree and build it from that?

It can't be any worse than what the broken 'make oldconfig' did to it.  What 
it output changed the disk drivers, graphic card drivers and just plain 
threw away at least a hundred lines in the multimedia drivers section.

How do you suggest I recover from this if just building from the 2.6.35.7 
.conf doesn't work?

-- 
Cheers, Gene
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Bedfellows make strange politicians.
