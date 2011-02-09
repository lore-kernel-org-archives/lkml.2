Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529Ab1BIJqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:46:18 -0500
Received: from www.tglx.de ([62.245.132.106]:45350 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753058Ab1BIJqR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:46:17 -0500
Date: Wed, 9 Feb 2011 10:46:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
In-Reply-To: <1297243631.9388.258.camel@zakaz.uk.xensource.com>
Message-ID: <alpine.LFD.2.00.1102091041450.31804@localhost6.localdomain6>
References: <20110205200108.921707839@linutronix.de>  <4D50641B.2090006@goop.org>  <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>  <4D506AE6.6080900@goop.org>  <1297173811.9388.95.camel@zakaz.uk.xensource.com> 
 <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>  <1297177506.9388.135.camel@zakaz.uk.xensource.com>  <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6>  <20110208162045.GB4606@dumpdata.com>
 <1297243631.9388.258.camel@zakaz.uk.xensource.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

B1;2401;0cOn Wed, 9 Feb 2011, Ian Campbell wrote:

> On Tue, 2011-02-08 at 16:20 +0000, Konrad Rzeszutek Wilk wrote:
> 
> > This is what I've in the stable/irq.rework [...] Please tell me if I messed up.
> 
> I tested v2.6.38-rc4:
> += git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip irq/for-xen
> += git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen stable/irq.rework
> 
> and all seems fine.

stable/irq.rework still has the resume hackery inside.

Thanks,

	tglx
