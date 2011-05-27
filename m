Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1E0Of0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 10:35:26 -0400
Received: from mail4.comsite.net ([205.238.176.238]:65529 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752720Ab1E0OfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 10:35:24 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Michal Simek <michal.simek@petalogix.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-mtd@lists.infradead.org>
Subject: Re: Unaligned jffs2 dnode address - tested by nandsim
In-Reply-To: <4DDB5F60.1080703@petalogix.com>
References: <4DD5022C.9060205@petalogix.com> <4DDB5F60.1080703@petalogix.com>
Date: Fri, 27 May 2011 09:35:18 -0500
X-Originating-IP: 71.22.127.106
Message-ID: <1306506918_8903@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal Simek wrote:
> Michal Simek wrote:
> >
> > Hi,
> >
> > I have reached one problem with jffs2 fs ecc tested by nandsim on
> > Microblaze.
>
> Any update on this? Does someone know if jffs dnode should be aligned or not?
> I have added some developers from mtd-utils.
> 
> I have also done test with the latest mtd-utils from git and
> there is still unaligned address.
> 
> Any suggestions?

I vaguely remember doingn some research in this area a few years ago
looking a report on linuxppc-dev about this and the kernel's unaligned
access was dependant on the device being given a mtd point function
which means the device is directly accessible in the cpus address space.

I don't remember much beyond that and don't have time to dig.  I am
just an observer with respect to linux mtd.

> 
> Thanks,
> Michal

Hope this helps your research,
milton
