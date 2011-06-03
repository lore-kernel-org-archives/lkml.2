Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab1FCLpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:45:24 -0400
Received: from vm4.telegraphics.com.au ([98.124.60.149]:40548 "EHLO
	vps4.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab1FCLpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:45:23 -0400
X-Greylist: delayed 1507 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jun 2011 07:45:23 EDT
Date: Fri, 3 Jun 2011 21:20:23 +1000 (EST)
From: Finn Thain <fthain@telegraphics.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Linux/m68k <linux-m68k@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: Convert to genirq (WIP)
In-Reply-To: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
Message-ID: <alpine.OSX.2.00.1106011300550.199@ibook.intranet>
References: <alpine.DEB.2.00.1105282010370.16617@ayla.of.borg>
User-Agent: Alpine 2.00 (OSX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sat, 28 May 2011, Geert Uytterhoeven wrote:

> Of course any help is welcome, especially for Mac

What kind of help are you looking for? I read through your patch series 
but I'm not sure how much work is left. Probably I need to look at a 
genirq reference implementation to get an idea of the goal...

> (with its maze of interrupt controllers)

Perhaps we do not need to model that complexity in generic irq terms?

The mac port could probably make good use of the irq startup and shutdown 
hooks though.

Finn
