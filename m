Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483Ab1GGVS3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:18:29 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:60409 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab1GGVS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:18:27 -0400
ORGANIZATION: Oracle Linux Engineering
USER-AGENT: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5)
 Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
Message-ID: <4E16224D.5040502@oracle.com>
Date: Thu, 7 Jul 2011 14:17:01 -0700 (PDT)
From: Randy Dunlap <randy.dunlap@oracle.com>
To: james_p_freyensee@linux.intel.com
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        sfr@canb.auug.org.au, christophe.guerard@intel.com,
        pranav.k.sanghadia@intel.com
Subject: Re: [PATCH] Add PCI config dependency for PTI.
References: <james_p_freyensee@linux.intel.com>
 <1310073145-18328-1-git-send-email-james_p_freyensee@linux.intel.com>
In-Reply-To: <1310073145-18328-1-git-send-email-james_p_freyensee@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4E16229E.009E:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/11 14:12, james_p_freyensee@linux.intel.com wrote:
> From: J Freyensee <james_p_freyensee@linux.intel.com>
> 
> Intel-Atom implementation of PTI will not work with PCI
> configured off, so the pti driver should not be compiled
> in the event someone does not enable PCI in the linux kernel.
> 
> Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
> Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Yes, that also.

Thanks.

> Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
> ---
>  drivers/misc/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> index 4e349cd..7fd32a6 100644
> --- a/drivers/misc/Kconfig
> +++ b/drivers/misc/Kconfig
> @@ -146,6 +146,7 @@ config PHANTOM
>  
>  config INTEL_MID_PTI
>  	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
> +	depends on PCI
>  	default n
>  	help
>  	  The PTI (Parallel Trace Interface) driver directs


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
