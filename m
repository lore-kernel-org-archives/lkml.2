Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab2GXKKq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 06:10:46 -0400
Received: from osrc3.amd.com ([217.9.48.20]:57773 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753611Ab2GXKKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 06:10:45 -0400
Date: Tue, 24 Jul 2012 12:10:41 +0200
From: Borislav Petkov <bp@amd64.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andre Przywara <andre.przywara@amd.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
Message-ID: <20120724101041.GA24739@aftab.osrc.amd.com>
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com>
 <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com>
 <20120721103715.GA3632@aftab.osrc.amd.com>
 <500E4960.8040307@parallels.com>
 <500E5951.5020900@amd.com>
 <500E5CDF.5000504@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500E5CDF.5000504@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 12:29:19PM +0400, Vladimir Davydov wrote:
> I guess that when the more advanced features become widely-used,
> vendors will offer new MSRs and/or CPUID faulting.

And this right there is the dealbreaker:

So what are you doing for cpus which have the advanced CPUID features
leafs but there are no MSRs to turn those bits off?

You surely need some software-only solution for the migration to work,
no?

If so, why not apply that solution to your hypervisor without touching
the kernel at all?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
