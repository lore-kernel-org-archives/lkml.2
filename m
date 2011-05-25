Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933395Ab1EYAsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 20:48:01 -0400
Received: from mga14.intel.com ([143.182.124.37]:4394 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933222Ab1EYAsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 20:48:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,264,1304319600"; 
   d="scan'208";a="1011948"
Date: Tue, 24 May 2011 17:47:16 -0700
From: Andi Kleen <ak@linux.intel.com>
To: "Yu, Fenghua" <fenghua.yu@intel.com>
Cc: "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] x86, intel: Output microcode revision
Message-ID: <20110525004716.GA18742@tassilo.jf.intel.com>
References: <1306278210-18285-1-git-send-email-andi@firstfloor.org>
 <BANLkTikoa494-bRWtbbXuE6eqLuH0ZPUTg@mail.gmail.com>
 <493994B35A117E4F832F97C4719C4C04011E214EC2@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <493994B35A117E4F832F97C4719C4C04011E214EC2@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 05:25:08PM -0700, Yu, Fenghua wrote:
> >@@ -300,6 +295,7 @@ static int apply_microcode(int cpu)
> >       struct ucode_cpu_info *uci;
> >      unsigned int val[2];
> >       int cpu_num;
> >+       struct cpuinfo_x86 *c = &cpu_data(cpu_num);
> 
> This is wrong. cpu_num is not initialized yet at this point. You need to assign c after cpu_num is initialized in the next statement.

Thanks. Stupid bug. I'll post an updated version.

-Andi
