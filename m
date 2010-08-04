Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab0HDNlK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:41:10 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:46400 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab0HDNlI (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 09:41:08 -0400
Date: Wed, 4 Aug 2010 09:38:30 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@kernel.org>
To: torvalds@linux-foundation.org
Cc: Peter Jones <pjones@redhat.com>, Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek <konrad@hera.kernel.org>,
        torvalds@linux-foundation.org, James.Bottomley@suse.de,
        linux-kernel@vger.kernel.org, lenb@kernel.org, michaelc@cs.wisc.edu,
        mcb30@ipxe.org
Subject: Re: [GIT PULL] iBFT features for v2.6.36 .. Question about LinuxCon.
Message-ID: <20100804133830.GA4789@phenom.dumpdata.com>
References: <20100802143642.GA15428@hera.kernel.org>
 <20100802195248.GB32503@andromeda.dapyr.net>
 <4C572A13.4010303@zytor.com>
 <201008022108.04024.konrad@kernel.org>
 <4C577EFA.4070003@zytor.com>
 <4C582918.5080602@redhat.com>
 <4C58A4E7.4030800@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C58A4E7.4030800@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C596DA0.01C0:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 04:23:19PM -0700, H. Peter Anvin wrote:
> On 08/03/2010 07:35 AM, Peter Jones wrote:
> > 
> > The current iBFT specification and the current code (this push) includes the
> > ability to specify the location of the iBFT table using the standard ACPI table
> > mechanism, which is required on UEFI machines supporting iBFT, and which I
> > would encourage non-UEFI machines to also use where possible.  Obviously some
> > systems, especially BIOS-based machines doing iSCSI boot on expansion cards,
> > have difficulty with this, so we're not planning on de-supporting the old
> > memory scanning method.
> > 
> 
> Not just expansion cards, but also post-INT19 software solutions.

Linus,

Aside the discussion we are having with hpa about expanding the iBFT
or morphing it in another beast I realized that the LinuxCon is right
around the corner.

I presume you are not going to be sitting in the back of a corner trying
to merge all of the GIT pulls right before Aug 14/15th during the
LinuxCon. So does that mean that the effective merge window is right
before LinuxCon?

If that is the case, ping! Please pull this in before you pull in
James's tree as he has patches (and post-post merge patches) that depend
on this tree.

Or by any chance are you expanding the merge window by an extra week?

P.S.
Sorry to be so noise about this, but in the past I had missed two merge
windows and I want to make sure I don't miss this one.
