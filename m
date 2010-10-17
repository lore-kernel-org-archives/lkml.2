Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab0JQRGV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 13:06:21 -0400
Received: from zmc.proxad.net ([212.27.53.206]:50698 "EHLO zmc.proxad.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757416Ab0JQRGU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 13:06:20 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Oct 2010 13:06:20 EDT
X-Spam-Flag: NO
X-Spam-Score: 0.706
From: Florian Fainelli <ffainelli@freebox.fr>
Organization: Freebox
To: Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [PATCH 1/9] MIPS: Decouple BMIPS CPU support from bcm47xx/bcm63xx SoC code
Date: Sun, 17 Oct 2010 18:59:43 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc6-amd64; KDE/4.4.5; x86_64; ; )
Cc: Ralf Baechle <ralf@linux-mips.org>, mbizon@freebox.fr,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
In-Reply-To: <17ebecce124618ddf83ec6fe8e526f93@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010171859.44942.ffainelli@freebox.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kevin,

Le Saturday 16 October 2010 23:22:30, Kevin Cernekee a écrit :
> BMIPS processor cores are used in 50+ different chipsets spread across
> 5+ product lines.  In many cases the chipsets do not share the same
> peripheral register layouts, the same register blocks, the same
> interrupt controllers, the same memory maps, or much of anything else.
> 
> But, across radically different SoCs that share nothing more than the
> same BMIPS CPU, a few things are still mostly constant:
> 
> SMP operations
> Access to performance counters
> DMA cache coherency quirks
> Cache and memory bus configuration
> 
> So, it makes sense to treat each BMIPS processor type as a generic
> "building block," rather than tying it to a specific SoC.  This makes it
> easier to support a large number of BMIPS-based chipsets without
> unnecessary duplication of code, and provides the infrastructure needed
> to support BMIPS-proprietary features.
> 
> Signed-off-by: Kevin Cernekee <cernekee@gmail.com>

I boot tested all of your nine patches on a BCM6348 system without problems.

Tested-by: Florian Fainelli <ffainelli@freebox.fr>
--
Florian
