Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932439Ab1EZQF5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 12:05:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:48846 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab1EZQFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 12:05:48 -0400
Date: Thu, 26 May 2011 09:05:22 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH -next] regulator: fix 88pm8607.c printk format warning
Message-Id: <20110526090522.5d8c684b.randy.dunlap@oracle.com>
In-Reply-To: <1305978663.3317.7.camel@odin>
References: <20110518145412.f6cba4ef.sfr@canb.auug.org.au>
	<20110518100722.76bd6fb6.randy.dunlap@oracle.com>
	<20110518194311.GB5077@opensource.wolfsonmicro.com>
	<1305978663.3317.7.camel@odin>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4DDE7A52.0002:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 21 May 2011 12:51:03 +0100 Liam Girdwood wrote:

> On Wed, 2011-05-18 at 12:43 -0700, Mark Brown wrote:
> > On Wed, May 18, 2011 at 10:07:22AM -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > Fix printk format warning (seen on x86_64) and change to unsigned
> > > output format:
> > > 
> > > drivers/regulator/88pm8607.c:417: warning: format '%d' expects type 'int', but argument 3 has type 'resource_size_t'
> > 
> > Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > --
> 
> Samuel, this doesn't apply against regulator-next. Iirc, the patches
> this is against went via mfd-next ? If, so any chance you could take
> this ?
> 
> Thanks !
> 
> Liam  

Samuel,
Do you need this patch resent to you?

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
