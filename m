Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab0DHCaf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 22:30:35 -0400
Received: from mail.windriver.com ([147.11.1.11]:58985 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab0DHCad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 22:30:33 -0400
Date: Thu, 8 Apr 2010 10:29:45 +0800
From: Yong Zhang <yong.zhang@windriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Jon Masters <jonathan@jonmasters.org>
Subject: Re: [Bug #15661] PROBLEM: crash on halt with
 2.6.34-0.16.rc2.git0.fc14.x86_64
Message-ID: <20100408022945.GA12905@windriver.com>
Reply-To: Yong Zhang <yong.zhang@windriver.com>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
 <JVS2s9dmTsP.A.uTH.ftPvLB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <JVS2s9dmTsP.A.uTH.ftPvLB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 08 Apr 2010 02:29:47.0609 (UTC) FILETIME=[5B880C90:01CAD6C3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 11:13:50PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15661
> Subject		: PROBLEM: crash on halt with 2.6.34-0.16.rc2.git0.fc14.x86_64
> Submitter	: Jon Masters <jonathan@jonmasters.org>
> Date		: 2010-03-26 15:29 (13 days old)
> Message-ID	: <1269617372.3779.234.camel@localhost>
> References	: http://marc.info/?l=linux-kernel&m=126961739803949&w=2
> 

Seems a duplicate of http://lkml.org/lkml/2010/3/20/142
and it's reslovled by commit a90110c61073eab95d1986322693c2b9a8a6a5f6

Thanks,
Yong

> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
