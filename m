Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754155Ab1BRJjw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 04:39:52 -0500
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:34427 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1BRJju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 04:39:50 -0500
X-SpamScore: -21
X-BigFish: VPS-21(zz1432N98dNzz1202hzz8275bh15d4Rz32i637h668h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LGT466-02-507-02
X-M-MSG: 
Date: Fri, 18 Feb 2011 10:39:57 +0100
From: Borislav Petkov <borislav.petkov@amd.com>
To: Dan Carpenter <error27@gmail.com>, Ingo Molnar <mingo@redhat.com>
CC: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "open list:AMD MICROCODE UPD..." <amd64-microcode@amd64.org>,
        open list <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [patch -next] x86, microcode, AMD: signedness bug in
 generic_load_microcode()
Message-ID: <20110218093957.GA29723@aftab>
References: <20110218091716.GA4384@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110218091716.GA4384@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 04:17:16AM -0500, Dan Carpenter wrote:
> install_equiv_cpu_table() returns type int.  It uses negative error
> codes so using an unsigned type breaks the error handling.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Yes, my bad, sorry.

Acked-by: Borislav Petkov <borislav.petkov@amd.com>

Ingo, this should go ontop of tip/x86/microcode please, for it fixes
10de52d6655e ("x86, microcode, AMD: Simplify install_equiv_cpu_table").

Thanks a bunch.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632

