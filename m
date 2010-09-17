Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924Ab0IQSGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 14:06:01 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:54547 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893Ab0IQSGA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 14:06:00 -0400
Date: Fri, 17 Sep 2010 20:05:53 +0200
From: Nils Radtke <lkml@think-future.de>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel-Liste <linux-kernel@vger.kernel.org>
Subject: Re: INFO: inconsistent lock state
Message-ID: <20100917180553.GC11576@localhost>
Reply-To: lkml@think-future.de
References: <20100913145102.GI25129@localhost>
 <201009162018.16966.maciej.rutecki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <201009162018.16966.maciej.rutecki@gmail.com>
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  That msg appeared on one of our notebooks, one which is very
  prone to panic. Because of that I switched the lock checking 
  on for .35.4 . The machine tends to die of sucking the batts 
  empty while sleeping over night (that batt is ok..). Or it dies
  when resuming from suspend or when using Xorg (submitted already
  a bunch of reports on various issues, this beast is picky).

  .35.4 is the first .35 running on this machine. Sorry, I just
  checked, I only activated it for .35.4 . Config for .34 had 
  it still disabled.

  Amongst others, those are now active:
  CONFIG_DEBUG_SPINLOCK=y
  CONFIG_DEBUG_MUTEXES=y
  CONFIG_DEBUG_LOCK_ALLOC=y
  CONFIG_PROVE_LOCKING=y

  Would you mind giving advice on which else debug parameter 
  to activate w/o performance loss (it's a productive work place)?

          Cheers,

              Nils


On Thu 2010-09-16 @ 08-18-16PM +0200, Maciej Rutecki wrote: 
# On poniedziałek, 13 września 2010 o 16:51:02 Nils Radtke wrote:
# >   Hi,
# > 
# >   Got this in the logs:
# > 
# > PM: Adding info for No Bus:vcs7
# > PM: Adding info for No Bus:vcsa7
# > initialized framebuffer f62c8580 with backing bo f62c0080
# > 
# > =================================
# > [ INFO: inconsistent lock state ]
# > 2.6.35.4 #11
# 
# Older versions works OK? eg. 2.6.35 or 2.6.34?
# 
# -- 
# Maciej Rutecki
# http://www.maciek.unixy.pl

-- 
