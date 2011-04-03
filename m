Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab1DCJA5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 05:00:57 -0400
Received: from ch1outboundpool.messaging.microsoft.com ([216.32.181.186]:52811
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750784Ab1DCJAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 05:00:55 -0400
X-SpamScore: -18
X-BigFish: VPS-18(zz1432N98dKzz1202hzz15d4R8275bh8275dhz32i637h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LJ2JPC-01-4YB-02
X-M-MSG: 
Date: Sun, 3 Apr 2011 11:00:43 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Len Brown <lenb@kernel.org>
CC: Borislav Petkov <bp@alien8.de>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, "x86@kernel.org" <x86@kernel.org>,
        "Rosenfeld, Hans" <Hans.Rosenfeld@amd.com>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>
Subject: Re: [PATCH 07/18] x86 idle: clarify AMD erratum 400 workaround -v2
Message-ID: <20110403090043.GA4315@aftab>
References: <c82cf78992a66bfa7f0c82aeb20ba6922127463b.1301724243.git.len.brown@intel.com>
 <68477f71a39cd0ba9acd40e94e49969cbe1bec79.1301724243.git.len.brown@intel.com>
 <20110402082316.GA21804@liondog.tnic>
 <alpine.LFD.2.02.1104021442460.18682@x980>
 <alpine.LFD.2.02.1104021521330.18682@x980>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1104021521330.18682@x980>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 03:22:39PM -0400, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> The workaround for AMD erratum 400 uses the term "c1e" falsely suggesting:
> 1. Intel C1E is somehow involved
> 2. All AMD processors with C1E are involved
> 
> Use the string "amd_c1e" instead of simply "c1e" to clarify that
> this workaround is specific to AMD's version of C1E.
> Use the string "e400" to clarify that the workaround is specific
> to AMD processors with Erratum 400.
> 
> This patch is text-substitution only, with no functional change.
> 
> cc: x86@kernel.org
> cc: Hans Rosenfeld <hans.rosenfeld@amd.com>
> cc: Andreas Herrmann <andreas.herrmann3@amd.com>
> Signed-off-by: Len Brown <len.brown@intel.com>

Looks good, thanks.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

