Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264Ab1DUIcf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:32:35 -0400
Received: from webhosting01.bon.m2soft.com ([195.38.20.32]:55328 "EHLO
	webhosting01.bon.m2soft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752966Ab1DUIcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:32:33 -0400
Date: Thu, 21 Apr 2011 10:28:15 +0200
From: Nicolas Kaiser <nikai@nikai.net>
To: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/acpi/utils.c: Fixed coding style issues
Message-ID: <20110421102815.5abf133e@absol.kitzblitz>
In-Reply-To: <1303341624.11397.2.camel@ks-ubuntu>
References: <1303341624.11397.2.camel@ks-ubuntu>
Organization: -
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwAQMAAABtzGvEAAAAAXNSR0IArs4c6QAAAAZQTFRF
 AJnV/f/88sgWwwAAAKNJREFUGNM10LENwyAQheFHKCgZgTVSRHI2gy5reROTDSiREvnyHhdXnwXS+
 T+ACJgBYTiGSmDDOTdR7XDeTi9ksxEcoKFcTOCJLO7kC5SWFjPZCR69nI9+x5u6OJM1RN5UYUiNKa
 ZRpHHUoqh1v8hKEZ1FSGCrYOvgVmxd9DIXcSJwLTycm7bj0e4wkJGB48w/FckAwUKl/OGDZAcqItk
 BU+wHXLqKsjYyPeMAAAAASUVORK5CYII=
X-Mailer: Claws Mail (Linux)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Karthigan Srinivasan <karthigan.srinivasan@hp.com>:
> Fixed brace and comment coding style issues in code.
> 
> Signed-off-by: Karthigan Srinivasan <karthigan.srinivasan@hp.com>
> ---
>  drivers/acpi/utils.c |   18 +++++++++---------
>  1 files changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/acpi/utils.c b/drivers/acpi/utils.c
> index b002a47..2cf81a1 100644
> --- a/drivers/acpi/utils.c
> +++ b/drivers/acpi/utils.c
> @@ -99,9 +99,9 @@ acpi_extract_package(union acpi_object *package,
>  
>  		union acpi_object *element = &(package->package.elements[i]);
>  
> -		if (!element) {
> +		if (!element) 
                             ^
You are introducing trailing whitespace.

>  			return AE_BAD_DATA;
> -		}
> +		
   ^^^^^^^^^^^^^
For every pair of braces you clean away, you're adding
two new coding style issues.

Best regards,
Nicolas Kaiser
