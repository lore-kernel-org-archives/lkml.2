Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755761Ab1DALCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 07:02:54 -0400
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13730
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751145Ab1DALCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 07:02:53 -0400
X-SpamScore: -8
X-BigFish: VPS-8(zz1432N98dKzz1202hzz8275bhz32i637h668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LIZ00J-02-5NO-02
X-M-MSG: 
Date: Fri, 1 Apr 2011 13:02:43 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Len Brown <lenb@kernel.org>
CC: <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-pm@lists.linux-foundation.org>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 9/9] x86 idle: delete mwait_idle()
Message-ID: <20110401110243.GN11175@alberich.amd.com>
References: <67e90d97e0a77df4acd0c75e1bacc7714e011f3e.1301550524.git.len.brown@intel.com>
 <9797d1edfe558e20297785ce5b4e26339b74ea2c.1301550524.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <9797d1edfe558e20297785ce5b4e26339b74ea2c.1301550524.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 02:03:24AM -0400, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> For ACPI mode, mwait_with_hints() in cstate.c is used instead of
> process.c's mwait_idle().
> 
> For INTEL_IDLE mode, the mwait in intel_idle() is used instead of
> process.c's mwait_idle().
> 
> So delete process.c's mwait_idle().
> This will change the behaviour of SMP sysgtems that are
> running !ACPI and !INTEL_IDLE kernels -- they will use
> HALT instead of MWAIT.
> 
> This deletes the "idle=mwait" parameter, and thus the
> boot_option_idle_override == IDLE_FORCE_MWAIT flag.
> 
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: Andreas Herrmann <andreas.herrmann3@amd.com>


Regards,
Andreas


