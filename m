Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab1BHUzH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:55:07 -0500
Received: from xenotime.net ([72.52.115.56]:53541 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755328Ab1BHUzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:55:04 -0500
Message-ID: <4D51ADA6.6000200@xenotime.net>
Date: Tue, 08 Feb 2011 12:55:02 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: james_p_freyensee@linux.intel.com
CC: gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
Subject: Re: [PATCH 02/12] Kernel documentation for the PTI feature.
References: <james_p_freyensee@linux.intel.com> <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com> <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
In-Reply-To: <1297193697-5417-3-git-send-email-james_p_freyensee@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/8/2011 11:34 AM, james_p_freyensee@linux.intel.com wrote:
> From: J Freyensee<james_p_freyensee@linux.intel.com>
>
> This provides Kernel documentation for the PTI
> feature for Linux mobile solutions.
>
> Signed-off-by: J Freyensee<james_p_freyensee@linux.intel.com>
> ---
>   Documentation/pti/pti_intel_mid.txt |   89 +++++++++++++++++++++++++++++++++++
>   1 files changed, 89 insertions(+), 0 deletions(-)
>   create mode 100644 Documentation/pti/pti_intel_mid.txt
>
> diff --git a/Documentation/pti/pti_intel_mid.txt b/Documentation/pti/pti_intel_mid.txt
> new file mode 100644
> index 0000000..b9c3f3a
> --- /dev/null
> +++ b/Documentation/pti/pti_intel_mid.txt
> @@ -0,0 +1,89 @@
> +The Intel MID PTI project is HW implemented in Intel Atom
> +system-on-a-chip designs based on the Parallel Trace
> +Interface for MIPI P1149.7 cJTAG standard.  The kernel solution
> +for this platform involves the following files:
> +
> +./include/linux/pti.h
> +./include/linux/n_tracesink.h
> +./drivers/.../n_tracerouter.c
> +./drivers/.../n_tracesink.c
> +./drivers/.../pti.c
> +
> +pti.c is the driver that enables various debugging features
> +popular on certain mobile manufacturers.  n_tracerouter.c
> +and n_tracesink.c allow extra system information to be
> +collected and routed to the pti driver, such as trace
> +debugging data from a modem.  Altough n_tracerouter

                                  Although

> +and n_tracesink are a part of the complete PTI solution,
> +these two line disciplines can work separate from

                                        separately

> +pti.c and route any data stream from one /dev/tty node
> +to another /dev/tty node via kernel-space.  This provides
> +a stable, reliable connection that will not break unless
> +the user-space application shuts down (plus avoids
> +kernel->user->kernel context switch overheads of routing
> +data).

~Randy
