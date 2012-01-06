Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab2AFQVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 11:21:36 -0500
Received: from smtp151.dfw.emailsrvr.com ([67.192.241.151]:45885 "EHLO
	smtp151.dfw.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157Ab2AFQVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 11:21:35 -0500
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Fri, 06 Jan 2012 11:21:35 EST
Message-ID: <4F071E19.60108@calxeda.com>
Date: Fri, 06 Jan 2012 10:15:21 -0600
From: Mark Langsdorf <mark.langsdorf@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Andreas Herrmann <andreas.herrmann3@amd.com>
CC: Dave Jones <davej@redhat.com>,
        "cpufreq@vger.kernel.org" <cpufreq@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] powernow-k8: Update copyright, maintainer and documentation
 information
References: <20120106145500.GI24451@alberich.amd.com> <20120106145933.GL24451@alberich.amd.com>
In-Reply-To: <20120106145933.GL24451@alberich.amd.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2012 08:59 AM, Andreas Herrmann wrote:
> 
> Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
> ---
>  drivers/cpufreq/powernow-k8.c |   17 ++++++++++-------
>  1 files changed, 10 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/cpufreq/powernow-k8.c b/drivers/cpufreq/powernow-k8.c
> index ad683ec..8f9b2ce 100644
> --- a/drivers/cpufreq/powernow-k8.c
> +++ b/drivers/cpufreq/powernow-k8.c
> @@ -1,10 +1,11 @@
>  /*
> - *   (c) 2003-2010 Advanced Micro Devices, Inc.
> + *   (c) 2003-2012 Advanced Micro Devices, Inc.
>   *  Your use of this code is subject to the terms and conditions of the
>   *  GNU general public license version 2. See "COPYING" or
>   *  http://www.gnu.org/licenses/gpl.html
>   *
> - *  Support : mark.langsdorf@amd.com
> + *  Maintainer:
> + *  Andreas Herrmann <andreas.herrmann3@amd.com>
>   *
>   *  Based on the powernow-k7.c module written by Dave Jones.
>   *  (C) 2003 Dave Jones on behalf of SuSE Labs
> @@ -16,12 +17,14 @@
>   *  Valuable input gratefully received from Dave Jones, Pavel Machek,
>   *  Dominik Brodowski, Jacob Shin, and others.
>   *  Originally developed by Paul Devriendt.
> - *  Processor information obtained from Chapter 9 (Power and Thermal Management)
> - *  of the "BIOS and Kernel Developer's Guide for the AMD Athlon 64 and AMD
> - *  Opteron Processors" available for download from www.amd.com
>   *
> - *  Tables for specific CPUs can be inferred from
> - *     http://www.amd.com/us-en/assets/content_type/white_papers_and_tech_docs/30430.pdf
> + *  Processor information obtained from Chapter 9 (Power and Thermal
> + *  Management) of the "BIOS and Kernel Developer's Guide (BKDG) for
> + *  the AMD Athlon 64 and AMD Opteron Processors" and section "2.x
> + *  Power Management" in BKDGs for newer AMD CPU families.
> + *
> + *  Tables for specific CPUs can be inferred from AMD's processor
> + *  power and thermal data sheets, (e.g. 30417.pdf, 30430.pdf, 43375.pdf)
>   */
>  
>  #include <linux/kernel.h>

Acked-by: Mark Langsdorf <mark.langsdorf@calxeda.com>

formerly mark.langsdorf@amd.com
