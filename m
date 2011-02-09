Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753999Ab1BIKQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:16:34 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:31029 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1BIKQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:16:33 -0500
X-IronPort-AV: E=Sophos;i="4.60,446,1291611600"; 
   d="scan'208";a="134991118"
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.1102091046240.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de>
	 <4D50641B.2090006@goop.org>
	 <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
	 <4D506AE6.6080900@goop.org>
	 <1297173811.9388.95.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
	 <1297177506.9388.135.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6>
	 <20110208162045.GB4606@dumpdata.com>
	 <1297243631.9388.258.camel@zakaz.uk.xensource.com>
	 <alpine.LFD.2.00.1102091041450.31804@localhost6.localdomain6>
	 <alpine.LFD.2.00.1102091046240.31804@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 9 Feb 2011 10:16:30 +0000
Message-ID: <1297246590.9388.329.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-09 at 09:48 +0000, Thomas Gleixner wrote:
> On Wed, 9 Feb 2011, Thomas Gleixner wrote:
> 
> > B1;2401;0cOn Wed, 9 Feb 2011, Ian Campbell wrote:
> > 
> > > On Tue, 2011-02-08 at 16:20 +0000, Konrad Rzeszutek Wilk wrote:
> > > 
> > > > This is what I've in the stable/irq.rework [...] Please tell me if I messed up.
> > > 
> > > I tested v2.6.38-rc4:
> > > += git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip irq/for-xen
> > > += git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/irq.rework
> > > 
> > > and all seems fine.
> > 
> > stable/irq.rework still has the resume hackery inside.
> 
> Also please check whether your stuff compiles and works with the
> following patch. x86 should be fine, if not please yell.

Applied on top of the above += your 4/4 patch.

Compiled and tested as dom0 and PV domU -- Works For Me (tm), incl PV
migration.

Thanks,
Ian.


