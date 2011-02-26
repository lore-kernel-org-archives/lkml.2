Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751584Ab1BZPAj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Feb 2011 10:00:39 -0500
Received: from adelie.canonical.com ([91.189.90.139]:37941 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1BZPAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Feb 2011 10:00:37 -0500
Date: Sat, 26 Feb 2011 09:00:32 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Burt Triplett <burt@pbjtriplett.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
Subject: Re: Performance/resume issues on Toshiba NB305
Message-ID: <20110226150032.GA2053@thinkpad-t410>
Mail-Followup-To: Burt Triplett <burt@pbjtriplett.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Venkatesh Pallipadi <venki@google.com>, Len Brown <lenb@kernel.org>
References: <20110225164239.GA24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252108190.2701@localhost6.localdomain6>
 <20110225212142.GC24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252231200.2701@localhost6.localdomain6>
 <20110225222900.GD24686@thinkpad-t410>
 <alpine.LFD.2.00.1102252330290.2701@localhost6.localdomain6>
 <4D689681.1030301@pbjtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D689681.1030301@pbjtriplett.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 09:58:25PM -0800, Burt Triplett wrote:
> Looks like the Toshiba NB305 has an Intel Atom processor in it.
> bits-327, released today, now detects Intel Atom processors, and no
> longer shows them as unknown.  We don't have any processor-specific
> tests for Atom yet, though we may add some in the future.  All of
> the general tests should work, however.

The new release detects the Atom processor okay, but in bits-327 the
system resets during the SMI frequency/latency test, whereas it didn't
with bits-316.

> Can you provide more details on which MSRs show up as inconsistent
> on your system?  They might represent actual bugs in your BIOS, but
> we might just need to add a few more entries to the Atom
> CPU-specific MSR blacklist as expected inconsistencies.

Here's what it says:

  (MSR 0x39 consistent): FAIL
  (MSR 0x199 consistent): FAIL
  (MSR 0x1a0 consistent): FAIL
  Summary: 7917 passed, 3 failed

I have 3 systems with this same processor, and they all report the same
thing here. 

Seth

