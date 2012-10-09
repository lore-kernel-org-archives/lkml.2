Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2JIOfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:35:17 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:51515 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab2JIOfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:35:12 -0400
Date: Tue, 9 Oct 2012 10:23:25 -0400
From: Konrad Rzeszutek Wilk <konrad@kernel.org>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Feng Tang <feng.tang@intel.com>,
        Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 01/49] ACPI: delelte more BFS/GTS related definition and
 code
Message-ID: <20121009142323.GA7639@phenom.dumpdata.com>
References: <1349554210-29978-1-git-send-email-lenb@kernel.org>
 <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a950c135e5b2be6ef7518d54d98a7901db1b377a.1349554105.git.len.brown@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 04:09:22PM -0400, Len Brown wrote:
> From: Feng Tang <feng.tang@intel.com>

The title has 'delete' misspelled.

> 
> This is a follow on for commmit 3f6f49c7 "ACPI: delete _GTS/_BFS support"
> to do more cleanup.
> 
> Signed-off-by: Feng Tang <feng.tang@intel.com>
> Signed-off-by: Bob Moore <robert.moore@intel.com>
> Signed-off-by: Len Brown <len.brown@intel.com>
> ---
>  drivers/acpi/acpica/hwxfsleep.c | 1 -
>  include/acpi/acnames.h          | 2 --
>  include/acpi/actypes.h          | 7 -------
>  3 files changed, 10 deletions(-)
> 
> diff --git a/drivers/acpi/acpica/hwxfsleep.c b/drivers/acpi/acpica/hwxfsleep.c
> index 1f165a7..0ff1ece 100644
> --- a/drivers/acpi/acpica/hwxfsleep.c
> +++ b/drivers/acpi/acpica/hwxfsleep.c
> @@ -381,7 +381,6 @@ ACPI_EXPORT_SYMBOL(acpi_enter_sleep_state)
>   * FUNCTION:    acpi_leave_sleep_state_prep
>   *
>   * PARAMETERS:  sleep_state         - Which sleep state we are exiting
> - *              flags               - ACPI_EXECUTE_BFS to run optional method
>   *
>   * RETURN:      Status
>   *
> diff --git a/include/acpi/acnames.h b/include/acpi/acnames.h
> index d988ac5..d2f61dd 100644
> --- a/include/acpi/acnames.h
> +++ b/include/acpi/acnames.h
> @@ -66,8 +66,6 @@
>  
>  /* Method names - these methods must appear at the namespace root */
>  
> -#define METHOD_PATHNAME__BFS    "\\_BFS"
> -#define METHOD_PATHNAME__GTS    "\\_GTS"
>  #define METHOD_PATHNAME__PTS    "\\_PTS"
>  #define METHOD_PATHNAME__SST    "\\_SI._SST"
>  #define METHOD_PATHNAME__WAK    "\\_WAK"
> diff --git a/include/acpi/actypes.h b/include/acpi/actypes.h
> index 3d00bd5..a85bae9 100644
> --- a/include/acpi/actypes.h
> +++ b/include/acpi/actypes.h
> @@ -519,13 +519,6 @@ typedef u64 acpi_integer;
>  #define ACPI_SLEEP_TYPE_INVALID         0xFF
>  
>  /*
> - * Sleep/Wake flags
> - */
> -#define ACPI_NO_OPTIONAL_METHODS        0x00	/* Do not execute any optional methods */
> -#define ACPI_EXECUTE_GTS                0x01	/* For enter sleep interface */
> -#define ACPI_EXECUTE_BFS                0x02	/* For leave sleep prep interface */
> -
> -/*
>   * Standard notify values
>   */
>  #define ACPI_NOTIFY_BUS_CHECK           (u8) 0x00
> -- 
> 1.8.0.rc0.18.gf84667d
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
