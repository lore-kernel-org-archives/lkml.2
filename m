Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0DTFBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 01:01:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57593 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118Ab0DTFBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 01:01:01 -0400
Date: Mon, 19 Apr 2010 21:58:37 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, linux-mtd@lists.infradead.org,
       hsweeten@visionengravers.com, dwmw2@infradead.org
Subject: Re: [Bug #15729] BUG: physmap modprobe & rmmod
Message-Id: <20100419215837.d4a9b01d.randy.dunlap@oracle.com>
In-Reply-To: <20100420045301.GF19957@pengutronix.de>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh>
	<YeFfFNFyTSF.A.MFH.fRSzLB@tosh>
	<20100420045301.GF19957@pengutronix.de>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4BCD34E8.00BF:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 06:53:01 +0200 Wolfram Sang wrote:

> On Tue, Apr 20, 2010 at 05:19:23AM +0200, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.33.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15729
> > Subject		: BUG: physmap modprobe & rmmod
> > Submitter	: Randy Dunlap <randy.dunlap@oracle.com>
> > Date		: 2010-04-02 20:40 (18 days old)
> > Message-ID	: <20100402134058.c4682716.randy.dunlap@oracle.com>
> > References	: http://marc.info/?l=linux-kernel&m=127024096210230&w=2
> 
> Patch is here:
> 
> 	https://patchwork.kernel.org/patch/90497/

Thanks.

> I'd ack it if I still had the original mail :)

I already replied with
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

> CCing linux-mtd and some more people, so it can get picked up.


---
~Randy
