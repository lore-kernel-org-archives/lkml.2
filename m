Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753468Ab0IVJ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 05:59:31 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:52762 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab0IVJ7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 05:59:30 -0400
Date: Wed, 22 Sep 2010 12:59:28 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Florian Mickler <florian@mickler.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: Re: [Bug #16971] qla4xxx compile failure on 32-bit PowerPC: missing
 readq and writeq
In-Reply-To: <20100922114612.6eeae729@schatten.dmk.lab>
Message-ID: <alpine.SOC.1.00.1009221253450.14750@math.ut.ee>
References: <1fwtoy8sG5H.A.veG.9D7lMB@chimera> <Wn2eLj_6KZG.A.SpH.KF7lMB@chimera> <alpine.SOC.1.00.1009221148550.14750@math.ut.ee> <20100922114612.6eeae729@schatten.dmk.lab>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16971
> > > Subject		: qla4xxx compile failure on 32-bit PowerPC: missing readq and writeq
> > > Submitter	: Meelis Roos <mroos@linux.ee>
> > > Date		: 2010-08-19 21:03 (33 days old)
> > > Message-ID	: <alpine.SOC.1.00.1008192359310.19654@math.ut.ee>
> > > References	: http://marc.info/?l=linux-kernel&m=128225184900892&w=2
> > 
> > Still present. The maintainer of the driver has a patch that I have 
> > tested, and for quite some time now, but it still does not appear in 
> > mainline.
> 
> Do you have a pointer to the maintainer and the patch, so that we can
> update the bugzilla entry and ping the maintainer? 

The patch was made by Vikas Chaudhary <vikas.chaudhary@qlogic.com> 
(CC:d) and sent to me by private me-mail. I was first dubious about 
possible endianness problem with qla4xxx private readq and writeq 
implementation but he told they forcefully tested it on PPC64 and it 
worked.

Last I heard from him on September 6th when he wrote he intended to push 
the patch upstream together with other patches the same week.

-- 
Meelis Roos (mroos@linux.ee)
