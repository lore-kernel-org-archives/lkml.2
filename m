Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096Ab1BHQZw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 11:25:52 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:65082 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1BHQZv (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 8 Feb 2011 11:25:51 -0500
Date: Tue, 8 Feb 2011 11:24:42 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/4] XEN: Interrupt cleanups
Message-ID: <20110208162442.GC4606@dumpdata.com>
References: <20110205200108.921707839@linutronix.de>
 <4D50641B.2090006@goop.org>
 <alpine.LFD.2.00.1102072231220.31804@localhost6.localdomain6>
 <4D506AE6.6080900@goop.org>
 <1297173811.9388.95.camel@zakaz.uk.xensource.com>
 <alpine.LFD.2.00.1102081544290.31804@localhost6.localdomain6>
 <1297177506.9388.135.camel@zakaz.uk.xensource.com>
 <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1102081619410.31804@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D516E84.0237:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Core change is in 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git irq/for-xen

I just noticed that the patch you put in there differs from the
one you posted: "genirq: Add IRQF_FORCE_RESUME". You missed the
changes in include/linux/interrupt.h for the IRQF_MODIFY_MASK.

Was that intentional?

