Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab0E1CkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 22:40:13 -0400
Received: from adelie.canonical.com ([91.189.90.139]:36800 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757756Ab0E1CkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 22:40:09 -0400
Subject: Re: [PATCH 8/8] intel_idle: create a native cpuidle driver for
 select intel processors
From: Chase Douglas <chase.douglas@canonical.com>
To: Len Brown <lenb@kernel.org>
Cc: x86@kernel.org, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
In-Reply-To: <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
References: <1274928151-30919-1-git-send-email-lenb@kernel.org>
	 <198450ec1600d9a7f55270dd4d44d6b55bc5b184.1274926772.git.len.brown@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 May 2010 22:32:13 -0400
Message-ID: <1275013933.2312.7.camel@cndougla-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-26 at 22:42 -0400, Len Brown wrote:
> +static struct cpuidle_state atom_cstates[MWAIT_MAX_NUM_CSTATES] = {
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "ATM-C1", "MWAIT 0x00", (void *) 0x00,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		1, 1000, 4, 0, 0, &intel_idle },
> +	{ "ATM-C2", "MWAIT 0x10", (void *) 0x10,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		20, 500, 80, 0, 0, &intel_idle },
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "ATM-C4", "MWAIT 0x30", (void *) 0x30,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		100, 250, 400, 0, 0, &intel_idle },
> +	{ "ATM-C6", "MWAIT 0x40", (void *) 0x40,
> +		CPUIDLE_FLAG_TIME_VALID,
> +		200, 150, 800, 0, 0, &intel_idle },
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0},
> +	{ "", "", 0, 0, 0, 0, 0, 0, 0, 0}
> +};

I see that you have updated this code in your tree to disable C4 and C6
on atom. This has piqued my curiosity. I've now seen 2 atom netbooks
from different OEMs that hide C4 when you plug the power in. After the
first machine I thought, "must be a BIOS/ACPI bug," but now I'm
beginning to wonder if there's some issue with atom C4 states? That's
beside the fact that I've not seen C6 on either machine at all. Do you
have any insight?

Thanks,

-- Chase

