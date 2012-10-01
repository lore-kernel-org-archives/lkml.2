Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751040Ab2JAEdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 00:33:00 -0400
Received: from www.xplot.org ([66.92.66.146]:53845 "EHLO www.xplot.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750708Ab2JAEc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 00:32:59 -0400
From: Tim Shepard <shep@alum.mit.edu>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: linux-kernel@vger.kernel.org
Subject: Re: CONFIG_EXPERT is a booby trap 
In-reply-to: Your message of Sun, 30 Sep 2012 20:24:46 -0700.
             <50690CFE.6010600@xenotime.net> 
Date: Mon, 01 Oct 2012 00:32:51 -0400
Message-Id: <E1TIXga-0008T1-00@www.xplot.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Interestingly, of the 26 configs that use EXPERT in the default
clause, 15 of them are in drivers/hid (see below).

			-Tim Shepard
			 shep@alum.mit.edu

 - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - - 

$ find . -type f -name Kconfig'*' -print | xargs fgrep default | grep EXPERT 
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/hid/Kconfig:  default !EXPERT
./drivers/media/common/tuners/Kconfig:  default y if !EXPERT
./drivers/media/common/tuners/Kconfig:  default y if EXPERT
./drivers/media/dvb/frontends/Kconfig:  default y if EXPERT
./drivers/media/video/Kconfig:  default y if !EXPERT
./init/Kconfig: default !EXPERT
./lib/Kconfig.debug:    default !EXPERT
./net/rfkill/Kconfig:   default y if !EXPERT
./usr/Kconfig:  default !EXPERT
./usr/Kconfig:  default !EXPERT
./usr/Kconfig:  default !EXPERT
./usr/Kconfig:  default !EXPERT
