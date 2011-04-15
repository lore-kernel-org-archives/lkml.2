Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384Ab1DOSaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:30:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31477 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab1DOSaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:30:23 -0400
Date: Fri, 15 Apr 2011 11:29:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: len.brown@intel.com, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix Kconfig dependencies for apei->pstore
Message-Id: <20110415112911.ba5f3023.randy.dunlap@oracle.com>
In-Reply-To: <4da5e1dc16852d7b29@agluck-desktop.sc.intel.com>
References: <20110413103109.76b9bb3d.rdunlap@xenotime.net>
	<4da5e1dc16852d7b29@agluck-desktop.sc.intel.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DA88EB7.007D:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Apr 2011 10:48:12 -0700 Luck, Tony wrote:

> Geert Uytterhoeven's dependency checker kicked out this warning:
> 
> + warning: (ACPI_APEI) selects PSTORE which has unmet direct dependencies (MISC_FILESYSTEMS):  => N/A
> 
> Randy confirmed that the fix was to "select MISC_FILESYSTEMS" too.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>

Tested-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
> 
> diff --git a/drivers/acpi/apei/Kconfig b/drivers/acpi/apei/Kconfig
> index 66a03ca..f739a70 100644
> --- a/drivers/acpi/apei/Kconfig
> +++ b/drivers/acpi/apei/Kconfig
> @@ -1,5 +1,6 @@
>  config ACPI_APEI
>  	bool "ACPI Platform Error Interface (APEI)"
> +	select MISC_FILESYSTEMS
>  	select PSTORE
>  	depends on X86
>  	help
> --


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
