Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab0LBRb0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 12:31:26 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:8748 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757253Ab0LBRbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 12:31:24 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 2/8] cpuidle: Rename X86 specific idle poll state[0] from C0 to CPUIDLE
Date: Thu, 2 Dec 2010 10:31:17 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-25-generic; KDE/4.4.2; x86_64; ; )
Cc: arjan@linux.intel.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <1291308148-28628-1-git-send-email-trenn@suse.de> <1291308148-28628-2-git-send-email-trenn@suse.de> <1291308148-28628-3-git-send-email-trenn@suse.de>
In-Reply-To: <1291308148-28628-3-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012021031.19779.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, December 02, 2010 09:42:22 am Thomas Renninger wrote:
> C0 means and is well know as "not idle".
> All documentation out there uses this term as "running"/"not idle"
> state. Also Linux userspace tools (e.g. cpufreq-aperf and turbostat)
> show C0 residency which there is correct, but means something totally
> else than cpuidle "POLL" state.
> 
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: arjan@linux.intel.com
> CC: lenb@kernel.org
> CC: linux-acpi@vger.kernel.org
> CC: Ingo Molnar <mingo@elte.hu>
> CC: linux-kernel@vger.kernel.org
> ---
>  drivers/cpuidle/cpuidle.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 08d5f05..99cc8fc 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -260,7 +260,7 @@ static void poll_idle_init(struct cpuidle_device *dev)
>  
>  	cpuidle_set_statedata(state, NULL);
>  
> -	snprintf(state->name, CPUIDLE_NAME_LEN, "C0");
> +	snprintf(state->name, CPUIDLE_NAME_LEN, "POLL");

The description says "rename C0 to CPUIDLE", but the patch looks like
"rename C0 to POLL".

>  	snprintf(state->desc, CPUIDLE_DESC_LEN, "CPUIDLE CORE POLL IDLE");
>  	state->exit_latency = 0;
>  	state->target_residency = 0;
> 
