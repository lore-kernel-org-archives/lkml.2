Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625Ab1BJQuR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:50:17 -0500
Received: from xenotime.net ([72.52.115.56]:49827 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756597Ab1BJQuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:50:16 -0500
Date: Thu, 10 Feb 2011 08:50:15 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Oren Weil <oren.jer.weil@intel.com>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        david@woodhou.se, david.woodhouse@intel.com
Subject: Re: [RFC PATCH 01/13] Intel(R) MEI Driver
Message-Id: <20110210085015.df3d47a6.rdunlap@xenotime.net>
In-Reply-To: <b9dded$htd8nk@orsmga002.jf.intel.com>
References: <b9dded$htd8nk@orsmga002.jf.intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 Feb 2011 01:54:57 -0800 Oren Weil wrote:

> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index b7980a8..0a54b26 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -1144,5 +1144,16 @@ config RAMOOPS
>  	  This enables panic and oops messages to be logged to a circular
>  	  buffer in RAM where it can be read back at some later point.
>  
> +config INTEL_MEI
> +	tristate "Intel(R) Management Engine Interface (Intel(R) MEI)"
> +	default m

Please don't enable random kconfig options.

> +	depends on EXPERIMENTAL && X86
> +	help
> +	  If you have an Intel(R) ME chip in your system 
> +	  say Yes to enable the Intel(R) Managment Engine interface.
> +	  for more informaiton see
> +	  <http://software.intel.com/en-us/manageability/>
> +
> +
>  endmenu

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
