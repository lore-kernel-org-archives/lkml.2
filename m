Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1HYLsu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 07:48:50 -0400
Received: from mx.treblig.org ([80.68.94.177]:39062 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365Ab1HYLst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 07:48:49 -0400
Date: Thu, 25 Aug 2011 12:48:48 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.1-rc3
Message-ID: <20110825114848.GA22287@gallifrey>
References: <1314260662-20452-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1314260662-20452-1-git-send-email-geert@linux-m68k.org>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.32.27-kvm-i386-20110114 (i686)
X-Uptime: 12:46:26 up 188 days, 13:19,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Geert Uytterhoeven (geert@linux-m68k.org) wrote:
>   + src/mm/memcontrol.c: error: this is the insn::  => 4108
>   + src/mm/memcontrol.c: error: unable to find a register to spill in class 'R0_REGS':  => 4108

That looks like a gcc problem rather than the kernel, maybe:
http://gcc.gnu.org/bugzilla/show_bug.cgi?id=38621

>From your detailed logs that's on the v3.1-rc3/sh4/se7206_defconfig config.

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
