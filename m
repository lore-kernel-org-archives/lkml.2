Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757019Ab2EKIFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:05:52 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:37956 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755588Ab2EKIFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:05:45 -0400
Date: Fri, 11 May 2012 17:05:40 +0900
From: Simon Horman <horms@verge.net.au>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        arnd@arndb.de, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@sisk.pl, lethal@linux-sh.org, olof@lixom.net
Subject: Re: [PATCH] mach-shmobile: Emma Mobile EV2 SMP prototype code
Message-ID: <20120511080534.GA8876@verge.net.au>
References: <20120509075407.5991.60556.sendpatchset@w520>
 <20120511071305.GD17741@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120511071305.GD17741@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 04:13:08PM +0900, Simon Horman wrote:
> On Wed, May 09, 2012 at 04:54:07PM +0900, Magnus Damm wrote:
> > From: Magnus Damm <damm@opensource.se>
> > 
> > Prototype code that adds SMP support to EMEV2.
> > 
> > At this point only the most basic form of SMP operation
> > is supported. TWD and CPU Hotplug support is excluded.
> > 
> > Based on V1 of the Emma Mobile EV2 code. Needs to be
> > reworked to coexist with DT. Work in progress.
> 
> Hi Magnus,
> 
> I tried out this patch on top of the next branch of Rafael's
> renesas tree (5658c94) plus V2 of your Emma Mobile EV2 code but
> I am only seeing one CPU.  Do I need some other tweaks?

Hi Magnus,

it turns out that I had maxcpus=1 set on the command line.
After removing that all seems well.

Tested-by: Simon Horman <horms@verge.net.au>

