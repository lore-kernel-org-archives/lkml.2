Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab1DRPvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 11:51:01 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:43902 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1DRPu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 11:50:56 -0400
Date: Mon, 18 Apr 2011 17:50:33 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "H. Peter Anvin" <hpa@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 4/4] x86, gart: Make sure GART does not map physmem above
 1TB
Message-ID: <20110418155033.GC8623@elte.hu>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
 <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
 <4DAC4EC0.80008@zytor.com>
 <4DAC5099.4010403@kernel.org>
 <20110418145941.GJ2192@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110418145941.GJ2192@amd.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roedel, Joerg <Joerg.Roedel@amd.com> wrote:

> On Mon, Apr 18, 2011 at 10:54:17AM -0400, H. Peter Anvin wrote:
> > On 04/18/2011 07:46 AM, H. Peter Anvin wrote:
> > > On 04/18/2011 06:45 AM, Joerg Roedel wrote:
> > >> The GART can only map physical memory below 1TB. Make sure
> > >> the gart driver in the kernel does not try to map memory
> > >> above 1TB.
> > > 
> > > Where does this limit come from?
> > 
> > Nevermind... despite the generic name of the file it looks to be
> > specific to the K8 GART.
> 
> Yes, this file mostly contains the dma-ops implementation that uses the
> K8 gart plus some k8-gart specific initialization functions.

Does the file want to be renamed to pci-amd_gart_64.c or so?

Thanks,

	Ingo
