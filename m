Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933307Ab0DHUBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:01:33 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40913 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933161Ab0DHUBa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:01:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yong Zhang <yong.zhang@windriver.com>
Subject: Re: [Bug #15661] PROBLEM: crash on halt with 2.6.34-0.16.rc2.git0.fc14.x86_64
Date: Thu, 8 Apr 2010 22:04:35 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera> <JVS2s9dmTsP.A.uTH.ftPvLB@chimera> <20100408022945.GA12905@windriver.com>
In-Reply-To: <20100408022945.GA12905@windriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004082204.35995.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 April 2010, Yong Zhang wrote:
> On Wed, Apr 07, 2010 at 11:13:50PM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15661
> > Subject		: PROBLEM: crash on halt with 2.6.34-0.16.rc2.git0.fc14.x86_64
> > Submitter	: Jon Masters <jonathan@jonmasters.org>
> > Date		: 2010-03-26 15:29 (13 days old)
> > Message-ID	: <1269617372.3779.234.camel@localhost>
> > References	: http://marc.info/?l=linux-kernel&m=126961739803949&w=2
> > 
> 
> Seems a duplicate of http://lkml.org/lkml/2010/3/20/142
> and it's reslovled by commit a90110c61073eab95d1986322693c2b9a8a6a5f6

Thanks, closing.

Rafael
