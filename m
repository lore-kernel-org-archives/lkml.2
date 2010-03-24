Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab0CXRAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:00:24 -0400
Received: from cable-static-49-187.intergga.ch ([157.161.49.187]:45084 "EHLO
	mail.ffwll.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932355Ab0CXRAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:00:19 -0400
X-Spam-ASN: 
X-Spam-Hammy: 0.000-+--UD:show_bug.cgi, 0.000-+--show_bugcgi,
	0.000-+--show_bug.cgi
X-Spam-Spammy: 0.993-1--plethora, 0.956-+--H*r:mail.ffwll.ch,
	0.945-+--H*Ad:D*ffwll.ch
Date: Wed, 24 Mar 2010 18:00:16 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Daniel Vetter <daniel@ffwll.ch>
Subject: Re: [Bug #15518] CONFIG_NO_BOOTMEM=y breaks boot on 32bit
Message-ID: <20100324170016.GB3552@viiv.ffwll.ch>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Kernel Testers List <kernel-testers@vger.kernel.org>,
	Maciej Rutecki <maciej.rutecki@gmail.com>
References: <M9dVcHY7TxH.A.2GC.ZBopLB@chimera>
 <3Qs6IGJaRe.A.BzC.CCopLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3Qs6IGJaRe.A.BzC.CCopLB@chimera>
X-Operating-System: Linux viiv 2.6.34-rc2-00116-gc643418 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 21, 2010 at 09:13:28PM +0100, Rafael J. Wysocki wrote:
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15518
> Subject		: CONFIG_NO_BOOTMEM=y breaks boot on 32bit
> Submitter	: Daniel Vetter <daniel@ffwll.ch>
> Date		: 2010-03-11 15:37 (11 days old)

I've just retested on 3.6.34-rc2. NO_BOOTMEM=y still crashes with a
plethora of backtraces somewhere in early boot. Disabling this option
still works around the problem
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
