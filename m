Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2JZMjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:39:52 -0400
Received: from londo.lunn.ch ([80.238.139.98]:53292 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932643Ab2JZMju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:39:50 -0400
Date: Fri, 26 Oct 2012 14:39:08 +0200
From: Andrew Lunn <andrew@lunn.ch>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/4] Adding SATA support for Armada 370/XP
Message-ID: <20121026123908.GH21046@lunn.ch>
References: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 26, 2012 at 02:30:45PM +0200, Gregory CLEMENT wrote:
> Hello,
> 
> this patch set adds the SATA support for Armada 370 and Armada XP. Few
> changes have been done since the first version by taking in account
> the comments received for the first version.
> 
> The evaluation boards for Armada 370 and Armada XP come with 2 SATA
> ports, and when both are enable the coherent pool for DMA mapping was
> too short. It was exactly the same issue that was fixed for Kirkwood
> two months ago. So I used the same fix in the first patch. Later when
> Kirkwood will be part of mach-mvebu, then this fix will be shared
> between the 2 SoCs families.
> 
> This patch set is based on 3.7-rc2 and depends one the framework clock
> support (the last version was posted last week:
> http://thread.gmane.org/gmane.linux.kernel/1375701). The git branch
> called mvebu-SATA-for-3.8 is also available at
> https://github.com/MISL-EBU-System-SW/mainline-public.git.

Hi Gregory

What about the openblocks-ax3?

     Andrew
