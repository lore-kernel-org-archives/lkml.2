Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1DSO34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:29:56 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:9994 "EHLO
	VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752079Ab1DSO3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:29:55 -0400
X-SpamScore: -34
X-BigFish: VPS-34(zzbb2dK9371O179dN1432N98dKzz1202hzz15d4Rz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJWLLP-02-0L2-02
X-M-MSG: 
Date: Tue, 19 Apr 2011 16:29:04 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: "H. Peter Anvin" <hpa@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH 4/4] x86, gart: Make sure GART does not map physmem
 above 1TB
Message-ID: <20110419142904.GT2192@amd.com>
References: <1303134346-5805-1-git-send-email-joerg.roedel@amd.com>
 <1303134346-5805-5-git-send-email-joerg.roedel@amd.com>
 <4DAC4EC0.80008@zytor.com>
 <4DAC5099.4010403@kernel.org>
 <20110418145941.GJ2192@amd.com>
 <20110418155033.GC8623@elte.hu>
 <20110419061259.GL2192@amd.com>
 <20110419072520.GD25353@elte.hu>
 <4DAD919A.3080102@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4DAD919A.3080102@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 09:43:54AM -0400, H. Peter Anvin wrote:
> On 04/19/2011 12:25 AM, Ingo Molnar wrote:
> >>>>
> >>>> Yes, this file mostly contains the dma-ops implementation that uses the
> >>>> K8 gart plus some k8-gart specific initialization functions.
> >>>
> >>> Does the file want to be renamed to pci-amd_gart_64.c or so?
> >>
> >> Hmm, that seems long. How about just amd64_gart.c?
> > 
> 
> Arguably we call this the k8_nb in other places, so my suggestion would
> be k8_gart.c

The k8_nb was renamed to amd_nb recently. The NB is implemented in all
64 bit AMD processors and there are more today then K8. The k8_nb was
historically chosen and misleading today.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

