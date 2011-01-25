Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752356Ab1AYBe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 20:34:27 -0500
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:58755 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752788Ab1AYBeX (ORCPT
	<rfc822;groupwise-jlee@novell.com:5:1>);
	Mon, 24 Jan 2011 20:34:23 -0500
Message-Id: <4D3EC34A020000230002799D@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 24 Jan 2011 18:34:18 -0700
From: "Joey Lee" <jlee@novell.com>
To: <jj@chaosbits.net>
Cc: <trivial@kernel.org>, <mjg@redhat.com>, <carlos@strangeworlds.co.uk>,
        <linux-kernel@vger.kernel.org>, <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH] X86, Acer, WMI: Do not double include linux/dmi.h
 in acer-wmi.c
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper, 

於 一，2011-01-24 於 22:12 +0100，Jesper Juhl 提到：
> Including linux/dmi.h once in drivers/platform/x86/acer-wmi.c is enough.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  acer-wmi.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
> index c5c4b8c..f21eb53 100644
> --- a/drivers/platform/x86/acer-wmi.c
> +++ b/drivers/platform/x86/acer-wmi.c
> @@ -39,7 +39,6 @@
>  #include <linux/slab.h>
>  #include <linux/input.h>
>  #include <linux/input/sparse-keymap.h>
> -#include <linux/dmi.h>
>  
>  #include <acpi/acpi_drivers.h>
>  
> 

Reviewed-by: Lee, Chun-Yi <jlee@novell.com>

Thank's for your patch to fix my fail.

Joey Lee

