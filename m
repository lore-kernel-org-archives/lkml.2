Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab2DISHU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:07:20 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40177 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab2DISHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:07:18 -0400
Date: Mon, 9 Apr 2012 19:07:11 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, peter.chubb@nicta.com.au,
        michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
Message-ID: <20120409180711.GA26277@srcf.ucam.org>
References: <4F8302B4.8040901@meetinghouse.net>
 <20120409155155.GA22974@srcf.ucam.org>
 <4F831BD0.3010707@meetinghouse.net>
 <20120409173223.GA25717@srcf.ucam.org>
 <4F83231A.8040005@meetinghouse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F83231A.8040005@meetinghouse.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2012 at 01:57:46PM -0400, Miles Fidelman wrote:
> Matthew Garrett wrote:
> >On Mon, Apr 09, 2012 at 01:26:40PM -0400, Miles Fidelman wrote:
> >
> >>No.  Tried all the combinations - w/ and w/o hypervisor, all the
> >>available kernel options.  Seems
> >>like the only thing that will reboot this particular hardware/bios
> >>combo is via the bios.
> >And this is with 3.3? Interesting. What's the exact behaviour you see,
> >and what motherboard is this?
> >
> 
> No.  2.6.32.5  (the one that currently ships with Debian stable).

Ok. The reboot code has been reworked since then. It'd be good to try it 
with a new kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
