Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab1HCWgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 18:36:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34357 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745Ab1HCWgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 18:36:32 -0400
Message-ID: <4E39CD63.409@zytor.com>
Date: Wed, 03 Aug 2011 15:36:19 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, x86@kernel.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH 5/5] cpuidle: stop depending on pm_idle
References: <1312400648-17636-1-git-send-email-lenb@kernel.org> <619b3f9e65307529dd4bbc98efe9d2f3b632646c.1312400543.git.len.brown@intel.com>
In-Reply-To: <619b3f9e65307529dd4bbc98efe9d2f3b632646c.1312400543.git.len.brown@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2011 12:44 PM, Len Brown wrote:
> From: Len Brown <len.brown@intel.com>
> 
> cpuidle users should call cpuidle_call_idle() directly
> rather than via (pm_idle)() function pointer.
> 
> Architecture may choose to continue using (pm_idle)(),
> but cpuidle need not depend on it:
> 
>   my_arch_cpu_idle()
> 	...
> 	if(cpuidle_call_idle())
> 		pm_idle();
> 
> cc: x86@kernel.org
> cc: Kevin Hilman <khilman@deeprootsystems.com>
> cc: Paul Mundt <lethal@linux-sh.org>
> Signed-off-by: Len Brown <len.brown@intel.com>

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

