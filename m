Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737Ab2JZMsQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:48:16 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:47039 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932694Ab2JZMsO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:48:14 -0400
Date: Fri, 26 Oct 2012 14:48:04 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Andrew Lunn <andrew@lunn.ch>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>,
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
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 0/4] Adding SATA support for Armada 370/XP
Message-ID: <20121026144804.640eabaf@skate>
In-Reply-To: <20121026123908.GH21046@lunn.ch>
References: <1351254650-26861-1-git-send-email-gregory.clement@free-electrons.com>
	<20121026123908.GH21046@lunn.ch>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 26 Oct 2012 14:39:08 +0200, Andrew Lunn wrote:

> What about the openblocks-ax3?

Grégory does not (yet) have an OpenBlocks AX3, but I'm planning to do
the work for SATA soon for this platform. However, supporting the
OpenBlocks AX3 is not part of our official contract with Marvell, it's
just an additional thing I'm happily doing on my spare time. So I'll
provide support for SATA, network and SMP on OpenBlocks AX3, but we
would like to first see the SATA support for the Marvell evaluation
boards being merged, and on my side the basic support for the
OpenBlocks AX3. I'll send followup patches to enable SATA/network/SMP
on OpenBlocks AX3 later on, if that's ok for you?

Thanks!

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
