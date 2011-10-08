Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1JHRg1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 13:36:27 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55189 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab1JHRgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 13:36:25 -0400
Date: Sat, 8 Oct 2011 13:36:21 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Eric Miao <eric.y.miao@gmail.com>
cc: Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH 18/26] ARM: pxa: MTD_XIP is not actually working any
 more
In-Reply-To: <CAMPhdO88OdwjfERo=Ri_-_xR75S53d-HKW1Ah0WGnu_0P1gRXQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1110081126150.6390@xanadu.home>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <1317499438-14058-19-git-send-email-arnd@arndb.de> <CAMPhdO88OdwjfERo=Ri_-_xR75S53d-HKW1Ah0WGnu_0P1gRXQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=US-ASCII
Content-ID: <alpine.LFD.2.02.1110081333411.6390@xanadu.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 8 Oct 2011, Eric Miao wrote:

> On Sun, Oct 2, 2011 at 4:03 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> > The headers files required for XIP support have moved around
> > over the last few years, and the code no longer builds.
> > Until someone fixes this, let's just disable support, leaving
> > sa1100 as the only platform still supporting xip.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> It is actually fixable, the problem is really mtd-xip.h is referencing
> the interrupt registers directly which I moved them to mach-pxa/irq.c
> for better modularization.
> 
> I'm fine to drop XIP. I'm afraid Nico's gonna be a bit disappointed
> as I broke his favorite XIP code :-)

Well, I don't care much myself.  I have no use for that capability, even 
though this was interesting to implement.  So it only depends if someone 
relies on this or not.

A few months ago I asked on the list if XIP was still useful, and Tim 
Bird replied that Sony was indeed using it.  So if this is not too hard 
to keep this feature alive then I'd go with that option.


Nicolas
