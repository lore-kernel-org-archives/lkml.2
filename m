Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab1E2PkQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 11:40:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53778 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165Ab1E2PkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 11:40:14 -0400
Date: Sun, 29 May 2011 08:40:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Kyungmin Park <kyungmin.park@samsung.com>,
        lkml <linux-kernel@vger.kernel.org>
Cc: Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: gpio: gpio-exynos4 build fails in mainline
Message-Id: <20110529084000.68a6351a.randy.dunlap@oracle.com>
In-Reply-To: <20110529083520.41730250.randy.dunlap@oracle.com>
References: <20110529083032.d3d16059.randy.dunlap@oracle.com>
	<20110529083520.41730250.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DE268DA.010E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011 08:35:20 -0700 Randy Dunlap wrote:

> On Sun, 29 May 2011 08:30:32 -0700 Randy Dunlap wrote:
> 
> > probably should depend on ARM or some ARM sub-arch/mach-type?
> > 
> > 
> > drivers/gpio/gpio-exynos4.c:18:11: error: unable to open 'mach/map.h'
> > 
> > 
> > on x86_64
> > 
> > ---
> 
> similarly:
> 
> drivers/gpio/gpio-plat-samsung.c:22:11: error: unable to open 'plat/gpio-core.h'


and

drivers/gpio/gpio-s5pc100.c:21:11: error: unable to open 'mach/map.h'


(this began as x86_64 allmodconfig)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
