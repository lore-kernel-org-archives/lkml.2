Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752915Ab1DSGNJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 02:13:09 -0400
Received: from am1ehsobe006.messaging.microsoft.com ([213.199.154.209]:42923
	"EHLO AM1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752320Ab1DSGNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 02:13:07 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zzbb2dK9371O179dN1432N98dKzz1202hzz15d4R8275bhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJVYLP-02-57Q-02
X-M-MSG: 
Date: Tue, 19 Apr 2011 08:12:59 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ingo Molnar <mingo@elte.hu>
CC: "H. Peter Anvin" <hpa@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 4/4] x86, gart: Make sure GART does not map physmem
 above 1TB
Message-ID: <20110419061259.GL2192@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
 <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
 <4DAC4EC0.80008@zytor.com>
 <4DAC5099.4010403@kernel.org>
 <20110418145941.GJ2192@amd.com>
 <20110418155033.GC8623@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110418155033.GC8623@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 18, 2011 at 11:50:33AM -0400, Ingo Molnar wrote:
> 
> * Roedel, Joerg <Joerg.Roedel@amd.com> wrote:
> 
> > On Mon, Apr 18, 2011 at 10:54:17AM -0400, H. Peter Anvin wrote:
> > > On 04/18/2011 07:46 AM, H. Peter Anvin wrote:
> > > > On 04/18/2011 06:45 AM, Joerg Roedel wrote:
> > > >> The GART can only map physical memory below 1TB. Make sure
> > > >> the gart driver in the kernel does not try to map memory
> > > >> above 1TB.
> > > > 
> > > > Where does this limit come from?
> > > 
> > > Nevermind... despite the generic name of the file it looks to be
> > > specific to the K8 GART.
> > 
> > Yes, this file mostly contains the dma-ops implementation that uses the
> > K8 gart plus some k8-gart specific initialization functions.
> 
> Does the file want to be renamed to pci-amd_gart_64.c or so?

Hmm, that seems long. How about just amd64_gart.c?

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

