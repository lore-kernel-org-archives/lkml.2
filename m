Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753996Ab1E2Poo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 11:44:44 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:36632 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750992Ab1E2Pon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 11:44:43 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=WdrMRjJnAzpB3xfxNTmwYkDHYEInk7C8nO+uj1QkAiI77nUJZpiNmloGHCQIRYBD30hhLLIP/hn4pxiK+zzjOR3iFUBf9FBGxawIiY+jnydSQG6tuXl/USuCid9DNNie;
Date: Sun, 29 May 2011 08:44:40 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: gpio: gpio-exynos4 build fails in mainline
Message-Id: <20110529084440.a4803072.rdunlap@xenotime.net>
In-Reply-To: <20110529084000.68a6351a.randy.dunlap@oracle.com>
References: <20110529083032.d3d16059.randy.dunlap@oracle.com>
	<20110529083520.41730250.randy.dunlap@oracle.com>
	<20110529084000.68a6351a.randy.dunlap@oracle.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 29 May 2011 08:40:00 -0700 Randy Dunlap wrote:

> On Sun, 29 May 2011 08:35:20 -0700 Randy Dunlap wrote:
> 
> > On Sun, 29 May 2011 08:30:32 -0700 Randy Dunlap wrote:
> > 
> > > probably should depend on ARM or some ARM sub-arch/mach-type?
> > > 
> > > 
> > > drivers/gpio/gpio-exynos4.c:18:11: error: unable to open 'mach/map.h'
> > > 
> > > 
> > > on x86_64
> > > 
> > > ---
> > 
> > similarly:
> > 
> > drivers/gpio/gpio-plat-samsung.c:22:11: error: unable to open 'plat/gpio-core.h'
> 
> 
> and
> 
> drivers/gpio/gpio-s5pc100.c:21:11: error: unable to open 'mach/map.h'
> 
> 
> (this began as x86_64 allmodconfig)

and

drivers/gpio/gpio-s5pv210.c:17:11: error: unable to open 'plat/gpio-core.h'


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
