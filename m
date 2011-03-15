Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932161Ab1COPll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 11:41:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16776 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755984Ab1COPlk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 11:41:40 -0400
Date: Tue, 15 Mar 2011 08:41:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Zeng Zhaoming <zengzm.kernel@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Zeng Zhaoming <zhaoming.zeng@freescale.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org
Subject: Re: [PATCH -next] soc: sgtl5000 uses regulator interfaces
Message-Id: <20110315084117.1e3a3a61.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTikivW3+V4QYh9Nt9FGXTefZiN9WbpAvGVeBJHNN@mail.gmail.com>
References: <20110304180027.20deb6c4.sfr@canb.auug.org.au>
	<20110304173357.23d36116.randy.dunlap@oracle.com>
	<20110305112936.GA30187@opensource.wolfsonmicro.com>
	<AANLkTikivW3+V4QYh9Nt9FGXTefZiN9WbpAvGVeBJHNN@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D7F88A5.004F,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 5 Mar 2011 20:41:38 +0800 Zeng Zhaoming wrote:

> On Sat, Mar 5, 2011 at 7:29 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Fri, Mar 04, 2011 at 05:33:57PM -0800, Randy Dunlap wrote:
> >> From: Randy Dunlap <randy.dunlap@oracle.com>
> >>
> >> sgtl5000 uses regulator interfaces, so make selecting it depend
> >> on REGULATOR.
> >>
> >> sgtl5000.c:(.text+0x4ae33): undefined reference to `regulator_unregister'
> >> sgtl5000.c:(.text+0x4af41): undefined reference to `rdev_get_drvdata'
> >> sgtl5000.c:(.text+0x4b191): undefined reference to `regulator_register'
> >
> 
> hi， Thanks for the report.
> 
> > Since the regulator on the device is optional this isn't the best fix,
> > the code should be updated to support building without regulator.
> 
> I will fix the code. If regulator not enabled, and the optional
> regulator not provided externally,
> a warning message will print out, and internal regulator will set
> directly by write register.
> > --

ping.  This build error still happens in linux-next 2011.0315.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
