Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754851Ab0IQOvE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 10:51:04 -0400
Received: from tx2ehsobe002.messaging.microsoft.com ([65.55.88.12]:22463 "EHLO
	TX2EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab0IQOvD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 10:51:03 -0400
X-SpamScore: -32
X-BigFish: VPS-32(zzbb2dK1432N98dN9371Pzz1202hzz8275bh15d4Rz32i2a8h43h)
X-WSS-ID: 0L8WBWF-02-2JL-02
X-M-MSG: 
Date: Fri, 17 Sep 2010 16:50:56 +0200
From: Borislav Petkov <borislav.petkov@amd.com>
To: Andi Kleen <ak@linux.intel.com>
CC: Conny Seidel <conny.seidel@amd.com>, Huang Ying <ying.huang@intel.com>,
        Len Brown <len.brown@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: 7ad6e9435596f692ff65f399da12816c94960185 breaks AMD f10h.
Message-ID: <20100917145056.GB4335@kryptos.osrc.amd.com>
References: <20100917145625.75d2a412@marah.osrc.amd.com>
 <4C936FFF.5030303@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C936FFF.5030303@linux.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>
Date: Fri, Sep 17, 2010 at 03:41:19PM +0200

>  On 9/17/2010 2:56 PM, Conny Seidel wrote:
> >Hi,
> >
> >Kernel v2.6.36-rc4-134-g03a7ab0 breaks with the OOPS below.
> >
> >Reverting the commitid in the subject fixes the issue.
> >This is because APEI is selected by default on X86 (X86&&  ACPI),
> >maybe a vendor check in the hest_init() might make sense.
> 
> It looks like your system has a duplicated hest source ID. They are supposed
> to have unique identifiers.
> 
> The kernel should not oops of course, but it's really a BIOS bug imho.

We're looking into the BIOS issue. But right you are, the kernel should
not oops on a BIOS bug - it's not like BIOS bugs are something which
never happens :)

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

