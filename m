Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab2JXL4K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:56:10 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:48017 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2JXL4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:56:07 -0400
Date: Wed, 24 Oct 2012 13:55:56 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, Russell King <linux@arm.linux.org.uk>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Lior Amsalem <alior@marvell.com>,
        Maen Suleiman <maen@marvell.com>, Tawfik Bayouk <tawfik@marvell.com>,
        Shadi Ammouri <shadi@marvell.com>, Eran Ben-Avi <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Jani Monoses <jani.monoses@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] arm: plat-orion: Add coherency attribute when setup
 mbus target
Message-ID: <20121024135556.157d2e59@skate>
In-Reply-To: <1351065841-18654-2-git-send-email-gregory.clement@free-electrons.com>
References: <1351065841-18654-1-git-send-email-gregory.clement@free-electrons.com>
	<1351065841-18654-2-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Oct 2012 10:04:00 +0200, Gregory CLEMENT wrote:
> Recent SoC such as Armada 370/XP came with the possibility to deal
> with the I/O coherency by hardware. In this case the transaction
> attribute of the window must be flagged as "Shared transaction". Once
> this flag is set, then the transactions will be forced to be sent
> through the coherency block, in other case transaction is driven
> directly to DRAM.
> 
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Reviewed-by: Yehuda Yitschak <yehuday@marvell.com>

Acked-by: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
