Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758131Ab1FQLzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 07:55:50 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:1773 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757852Ab1FQLzp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 07:55:45 -0400
Date: Fri, 17 Jun 2011 13:55:28 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: hwmon: (k10temp) update documentation
Message-ID: <20110617135528.5ea24270@endymion.delvare>
In-Reply-To: <4DF9ECF3.20700@ladisch.de>
References: <4DF9ECF3.20700@ladisch.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Clemens,

On Thu, 16 Jun 2011 13:45:55 +0200, Clemens Ladisch wrote:
> Add some CPU series IDs and links to the Fam12h datasheets.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>
> 
> --- a/Documentation/hwmon/k10temp
> +++ b/Documentation/hwmon/k10temp
> @@ -9,8 +9,8 @@ Supported chips:
>    Socket S1G3: Athlon II, Sempron, Turion II
>  * AMD Family 11h processors:
>    Socket S1G2: Athlon (X2), Sempron (X2), Turion X2 (Ultra)
> -* AMD Family 12h processors: "Llano"
> -* AMD Family 14h processors: "Brazos" (C/E/G-Series)
> +* AMD Family 12h processors: "Llano" (E2/A4/A6/A8-Series)
> +* AMD Family 14h processors: "Brazos" (C/E/G/Z-Series)
>  * AMD Family 15h processors: "Bulldozer"
>  
>    Prefix: 'k10temp'
> @@ -20,12 +20,16 @@ Supported chips:
>      http://support.amd.com/us/Processor_TechDocs/31116.pdf
>    BIOS and Kernel Developer's Guide (BKDG) for AMD Family 11h Processors:
>      http://support.amd.com/us/Processor_TechDocs/41256.pdf
> +  BIOS and Kernel Developer's Guide (BKDG) for AMD Family 12h Processors:
> +    http://support.amd.com/us/Processor_TechDocs/41131.pdf
>    BIOS and Kernel Developer's Guide (BKDG) for AMD Family 14h Models 00h-0Fh Processors:
>      http://support.amd.com/us/Processor_TechDocs/43170.pdf
>    Revision Guide for AMD Family 10h Processors:
>      http://support.amd.com/us/Processor_TechDocs/41322.pdf
>    Revision Guide for AMD Family 11h Processors:
>      http://support.amd.com/us/Processor_TechDocs/41788.pdf
> +  Revision Guide for AMD Family 12h Processors:
> +    http://support.amd.com/us/Processor_TechDocs/44739.pdf
>    Revision Guide for AMD Family 14h Models 00h-0Fh Processors:
>      http://support.amd.com/us/Processor_TechDocs/47534.pdf
>    AMD Family 11h Processor Power and Thermal Data Sheet for Notebooks:

Thanks for the update, applied.

-- 
Jean Delvare
