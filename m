Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759756Ab2FANMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:12:49 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:46070 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759738Ab2FANMq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:12:46 -0400
Date: Fri, 1 Jun 2012 16:12:45 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Jean Delvare <khali@linux-fr.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: f71805f arch dependencies?
In-Reply-To: <CAMuHMdXtZg7JJ18Ao+yLJ5s-vHt38Omgp=b4vOOFet870Buuzw@mail.gmail.com>
Message-ID: <alpine.SOC.1.00.1206011610060.10517@math.ut.ee>
References: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee> <CAMuHMdXtZg7JJ18Ao+yLJ5s-vHt38Omgp=b4vOOFet870Buuzw@mail.gmail.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Loading f71805f on sparc64 causes hard reboot beacuse on invalid
> > hardware access. Should this driver be restricted to PC, or some wider
> > subset of platforms where this LPC SUper-IO chip is present?
> 
> Which tree is f71805f in? Not in Linus'.

Running upstream 3.4.0-09547-gfb21aff and it is there as 
SENSORS_F71805F.

In fact, there are more LPC hwmon drivers that people can use to "shoot 
themselves in the leg" - SMSC LPC*, SMSC SCH*, SMSC DME1737 (partly I2C, 
partly ISA IO), and Fintek F71882FG and compatibles. Maybe more.

-- 
Meelis Roos (mroos@linux.ee)
