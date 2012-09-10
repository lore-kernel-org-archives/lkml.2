Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518Ab2IJSQg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 14:16:36 -0400
Received: from mail.x86-64.org ([217.9.48.20]:42984 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077Ab2IJSQf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 14:16:35 -0400
Date: Mon, 10 Sep 2012 20:16:14 +0200
From: Borislav Petkov <bp@amd64.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        andreas.herrmann3@amd.com, bp@amd64.org, robert.richter@amd.com,
        linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Andr=E9?= Przywara <andre.przywara@amd.com>
Subject: Re: [PATCH v2 0/5] eagerfpu patches for tip/x86/fpu
Message-ID: <20120910181614.GE4365@aftab.osrc.amd.com>
References: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347300665-6209-1-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 11:11:00AM -0700, Suresh Siddha wrote:

+ Andre.

> v2 version of the previous patchset https://lkml.org/lkml/2012/9/7/548
> that decouples eagerfpu into a synthetic cpuid feature.
> 
> changes from v1:
> * Made "eagerfpu=" boot parameter tri-state
> * removed the cpu_has_xmm check in the fx_finit (not related to eagerfpu
>   per-say, but this patchset touches that area of code).
> 
> Suresh Siddha (5):
>   x86, fpu: decouple non-lazy/eager fpu restore from xsave
>   x86, fpu: enable eagerfpu by default for xsaveopt
>   x86, fpu: move check_fpu() after alternative_instructions()
>   x86, fpu: make eagerfpu= boot param tri-state
>   x86, fpu: remove cpu_has_xmm check in the fx_finit()
> 
>  Documentation/kernel-parameters.txt |    6 ++
>  arch/x86/include/asm/cpufeature.h   |    3 +
>  arch/x86/include/asm/fpu-internal.h |   53 ++++++++++++++------
>  arch/x86/kernel/cpu/bugs.c          |    7 ++-
>  arch/x86/kernel/cpu/common.c        |    2 -
>  arch/x86/kernel/i387.c              |   25 +++------
>  arch/x86/kernel/process.c           |    2 +-
>  arch/x86/kernel/traps.c             |    2 +-
>  arch/x86/kernel/xsave.c             |   95 ++++++++++++++++++++++++-----------
>  9 files changed, 129 insertions(+), 66 deletions(-)
> 
> -- 
> 1.7.6.5
> 
> 

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
