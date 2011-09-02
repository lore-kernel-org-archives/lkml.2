Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933152Ab1IBDAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:00:48 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:57754 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933111Ab1IBDAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:00:47 -0400
Date: Fri, 2 Sep 2011 03:01:40 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>, mingo@redhat.com, hpa@zytor.com,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, JBeulich@novell.com,
        xen-devel@lists.xensource.com, Lars Boegild Thomsen <lth@cow.dk>,
        Len Brown <len.brown@intel.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend (Re:
 [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating them)
Message-ID: <20110902030140.GA31569@hallyn.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <20110829041532.GA22087@elie.gateway.2wire.net>
 <1314752662.6411.26.camel@nimitz>
 <20110831082230.GA4539@elie.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110831082230.GA4539@elie.gateway.2wire.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jonathan Nieder (jrnieder@gmail.com):
> Hi Dave,
> 
> Dave Hansen wrote:
> 
> > I'm seeing the exact same symptoms on my S10-3, fwiw.  They definitely
> > don't happen when intel_idle is compiled out or when
> > intel_idle.max_cstate=0 is specified on the kernel command-line.
> 
> Lars reminds me[1] that the kernel he was testing already had the
> intel_idle driver compiled out, so you're probably seeing a different
> (possibly related) bug.  (By the way, Lars, it is fine to communicate
> with lkml directly. :)  The people there don't bite.)

Right, over the past year or so this has been hit or miss.  Sometimes
intel_idle.max_cstate=0 would fix it.  Sometimes (like today) not.  Ever
since the problems have started, using intel_idle has not worked once,
but disabling it is not 100% reliable.  And when it doesn't work, it
doesn't work at all until I get a new kernel.

Sorry, not very helpful.

-serge
