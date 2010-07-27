Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0G0K7A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 06:59:00 -0400
Received: from smtp.nokia.com ([192.100.122.230]:40481 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755664Ab0G0K67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 06:58:59 -0400
Subject: Re: [PATCH] cpuidle: Remove references to ACPI
From: Ameya Palande <ameya.palande@nokia.com>
To: "len.brown@intel.com" <len.brown@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1279726766-19450-1-git-send-email-ameya.palande@nokia.com>
References: <1279726766-19450-1-git-send-email-ameya.palande@nokia.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Tue, 27 Jul 2010 13:58:17 +0300
Message-ID: <1280228297.1934.36.camel@chotu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Jul 2010 10:58:18.0685 (UTC) FILETIME=[9EFD46D0:01CB2D7A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-21 at 17:39 +0200, Palande Ameya (Nokia-MS/Helsinki)
wrote:
> Since cpuidle is generic framework and ACPI doesn't exist for non-x86
> platforms, remove references to ACPI from Kconfig.
> 
> Signed-off-by: Ameya Palande <ameya.palande@nokia.com>
> ---
>  drivers/cpuidle/Kconfig |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/cpuidle/Kconfig b/drivers/cpuidle/Kconfig
> index 7dbc4a8..512d25a 100644
> --- a/drivers/cpuidle/Kconfig
> +++ b/drivers/cpuidle/Kconfig
> @@ -1,14 +1,11 @@
> -
>  config CPU_IDLE
>  	bool "CPU idle PM support"
> -	default ACPI
> +	default PM
>  	help
>  	  CPU idle is a generic framework for supporting software-controlled
>  	  idle processor power management.  It includes modular cross-platform
>  	  governors that can be swapped during runtime.
>  
> -	  If you're using an ACPI-enabled platform, you should say Y here.
> -
>  config CPU_IDLE_GOV_LADDER
>  	bool
>  	depends on CPU_IDLE

Ping?

