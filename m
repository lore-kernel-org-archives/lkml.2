Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932073Ab2HTPb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:31:27 -0400
Received: from mail.x86-64.org ([217.9.48.20]:52850 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757066Ab2HTPbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:31:19 -0400
Date: Mon, 20 Aug 2012 17:31:10 +0200
From: Borislav Petkov <bp@amd64.org>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 05/11] x86/microcode_intel_lib.c: Early update ucode on
 Intel's CPU
Message-ID: <20120820153109.GA8623@aftab.osrc.amd.com>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-6-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345277729-8399-6-git-send-email-fenghua.yu@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 01:15:23AM -0700, Fenghua Yu wrote:
> From: Fenghua Yu <fenghua.yu@intel.com>
> 
> Define interfaces microcode_sanity_check() and get_matching_microcode(). They
> are called both in early boot time and in microcode Intel driver.
> 
> Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>

Actually,

this one should be merged with 3/11 to kill the build error.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
