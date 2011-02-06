Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1BFQqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 11:46:06 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:42669 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841Ab1BFQqE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 11:46:04 -0500
Date: Sun, 6 Feb 2011 17:44:45 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>,
        "Dr. David Alan Gilbert" <linux@treblig.org>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Message-ID: <20110206174445.19419b0f@galadriel2.home>
In-Reply-To: <alpine.DEB.2.00.1102060817590.28109@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
	<20110205214550.3cb0f0d1@galadriel2.home>
	<alpine.DEB.2.00.1102051553591.8518@p34.internal.lan>
	<20110205220621.GB17347@gallifrey>
	<alpine.DEB.2.00.1102051729010.8518@p34.internal.lan>
	<alpine.DEB.2.00.1102051753100.8518@p34.internal.lan>
	<4D4DE34E.7010308@hardwarefreak.com>
	<alpine.DEB.2.00.1102051958370.28109@p34.internal.lan>
	<4D4E127D.3060105@hardwarefreak.com>
	<alpine.DEB.2.00.1102060515230.28109@p34.internal.lan>
	<alpine.DEB.2.00.1102060817590.28109@p34.internal.lan>
Organization: Intellique
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sun, 6 Feb 2011 08:46:08 -0500 (EST) vous écriviez:

> # for 3ware raid, use 16384 readahead, > 16384 readahead, no
> improvement blockdev --setra 16384 /dev/sda

Also try this :

echo 512 > /sys/block/sda/queue/nr_requests

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------
