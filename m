Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1HaIWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 04:22:47 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39279 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753Ab1HaIWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 04:22:42 -0400
Date: Wed, 31 Aug 2011 03:22:30 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Kevin Tian <kevin.tian@intel.com>, mingo@redhat.com, hpa@zytor.com,
        Ian Campbell <Ian.Campbell@eu.citrix.com>, JBeulich@novell.com,
        xen-devel@lists.xensource.com, Lars Boegild Thomsen <lth@cow.dk>,
        Len Brown <len.brown@intel.com>
Subject: Re: [regression] Ideapad S10-3 does not wake up from suspend (Re:
 [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating them)
Message-ID: <20110831082230.GA4539@elie.gateway.2wire.net>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <20110829041532.GA22087@elie.gateway.2wire.net>
 <1314752662.6411.26.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314752662.6411.26.camel@nimitz>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

Dave Hansen wrote:

> I'm seeing the exact same symptoms on my S10-3, fwiw.  They definitely
> don't happen when intel_idle is compiled out or when
> intel_idle.max_cstate=0 is specified on the kernel command-line.

Lars reminds me[1] that the kernel he was testing already had the
intel_idle driver compiled out, so you're probably seeing a different
(possibly related) bug.  (By the way, Lars, it is fine to communicate
with lkml directly. :)  The people there don't bite.)

Over and out,
Jonathan

[1] http://bugs.debian.org/635575#42
(.config attached to that bug in a later comment)
