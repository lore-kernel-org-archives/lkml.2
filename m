Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866Ab1K2DJe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:09:34 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:40426 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab1K2DJd (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Mon, 28 Nov 2011 22:09:33 -0500
Subject: Re: [PATCH] Don't show error if Acer WMI is not found
From: joeyli <jlee@suse.com>
To: William Douglas <william.r.douglas@gmail.com>
Cc: linux-kernel@vger.kernel.org, pascal@unilogicnetworks.net, jlee@novell.com,
        joe@perches.com
In-Reply-To: <8762i4dnkw.fsf@intel.com>
References: <8762i4dnkw.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Nov 2011 11:07:05 +0800
Message-ID: <1322536025.6029.667.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 一，2011-11-28 於 12:00 -0800，William Douglas 提到：
> >From 486df5137ae34a4057d604e2b645d7b3848a562f Mon Sep 17 00:00:00 2001
> From: William Douglas <william.douglas@intel.com>
> Date: Mon, 28 Nov 2011 11:30:26 -0800
> Subject: [PATCH] Don't show error if Acer WMI is not found.
> 
> This patch initiated by Pascal seemed to get left out when switching
> to pr_<level>. I've updated the patch and am resubmitting it as it
> reduces unnecessary boot noise.
> 
> Signed-off-by: William Douglas <william.douglas@intel.com>
> ---
>  drivers/platform/x86/acer-wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index b848277..607af16 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -1946,7 +1946,7 @@ static int __init acer_wmi_init(void)
>  		AMW0_find_mailled();
>  
>  	if (!interface) {
> -		pr_err("No or unsupported WMI interface, unable to load\n");
> +		pr_info("No or unsupported WMI interface, unable to load\n");
>  		return -ENODEV;
>  	}
>  

Signed-off-by: Lee, Chun-Yi <jlee@novell.com>

It looks good to me!


Thanks for your patch
Joey Lee

