Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab1LFNqR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 08:46:17 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:35582 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1LFNqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 08:46:14 -0500
Date: Tue, 6 Dec 2011 13:46:07 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: intel-gfx@lists.freedesktop.org, joeyli <jlee@suse.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        platform-driver-x86@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [BUG] i915/intel-acpi.c: failed to get supported _DSM
 functions (was: [Dual-LVDS Acer Iconia laptop] i915/DRM issue: one screen
 stays off)
Message-ID: <20111206134607.GA11462@srcf.ucam.org>
References: <20111204160728.GA27292@archminux>
 <1323054041.6046.79.camel@linux-s257.site>
 <20111205205647.GA1757@archminux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205205647.GA1757@archminux>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 09:56:47PM +0100, Baptiste Jonglez wrote:
> CC-ing intel-gfx@lists.freedesktop.org (see below)
> On Mon, Dec 05, 2011 at 11:00:41AM +0800, joeyli wrote:
> > >   [drm:intel_dsm_pci_probe] *ERROR* failed to get supported _DSM functions
> > > 
> > > (attached is the relevant part of dmesg [1])
> > > 
> > > 
> > 
> > Have no idea for this _DSM error, need help from drm and acpi experts.
> 
> It definitely looks like an ACPI issue.
> That function is defined in `drivers/gpu/drm/i915/intel_acpi.c'.
> The whole file was added more than a year ago by commit 723bfd707a97
> (see the relevant thread on intel-gfx@ [1]) to "add _DSM support".
> One of the first comment is about "Calpella", which is exactly the
> platform of my laptop (as shown by lshw)

Ignore that - it's entirely harmless.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
