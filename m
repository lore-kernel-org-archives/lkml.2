Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932643Ab2FGRtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:49:09 -0400
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:7216 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932414Ab2FGRtH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:49:07 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI1432Izz1202hzz8275bhz2dh668h839h944hd25hf0ah)
X-WSS-ID: 0M59DHP-01-5JL-02
X-M-MSG: 
Date: Thu, 7 Jun 2012 19:49:23 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Chen Gong <gong.chen@linux.intel.com>, <x86@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [patch 4/5] x86: mce: Remove the frozen cases in the hotplug code
Message-ID: <20120607174923.GF16941@aftab.osrc.amd.com>
References: <20120606214941.104735929@linutronix.de>
 <20120606215116.684169600@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120606215116.684169600@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 09:53:24PM +0000, Thomas Gleixner wrote:
> No point in having double cases if we can simply mask the FROZEN bit
> out.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551

