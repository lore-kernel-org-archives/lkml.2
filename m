Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1BEUrI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 15:47:08 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:50659 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431Ab1BEUrG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 15:47:06 -0500
Date: Sat, 5 Feb 2011 21:45:50 +0100
From: Emmanuel Florac <eflorac@intellique.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-net@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: Supermicro X8DTH-6: Only ~250MiB/s from RAID<->RAID over 10GbE?
Message-ID: <20110205214550.3cb0f0d1@galadriel2.home>
In-Reply-To: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
References: <alpine.DEB.2.00.1102051427360.8518@p34.internal.lan>
Organization: Intellique
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Sat, 5 Feb 2011 14:35:52 -0500 (EST) vous écriviez:

> No single component is < 1Gbyte/sec but when data is transferred from 
> hostA to hostB, then it degrades to 250MiB/s.

Running 2 Supermicro H8-DIi+ with 2378 Opteron, Intel 10 GigE CX4, 3Ware
RAID-6 24 drives : 550 MB/s reading sustained over NFS with 2.6.32.*
(plain vanilla kernel).

I know that Xeon used to suck IO wise, but this is surprising. Isn't
something preventing DMA ?

-- 
------------------------------------------------------------------------
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
------------------------------------------------------------------------
