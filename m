Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669Ab2INST2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 14:19:28 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57284 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190Ab2INST0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 14:19:26 -0400
Message-ID: <505374E2.5080308@mvista.com>
Date: Fri, 14 Sep 2012 22:18:10 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: arnd@arndb.de, xen-devel@lists.xensource.com, linaro-dev@lists.linaro.org,
        Ian.Campbell@citrix.com, konrad.wilk@oracle.com,
        catalin.marinas@arm.com, tim@xen.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 12/24] xen/arm: introduce CONFIG_XEN on ARM
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-12-git-send-email-stefano.stabellini@eu.citrix.com>
In-Reply-To: <1347621207-11294-12-git-send-email-stefano.stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/14/2012 03:13 PM, Stefano Stabellini wrote:

> Changes in v2:

> - mark Xen guest support on ARM as EXPERIMENTAL.

> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/arm/Kconfig |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 2f88d8d..e92518d 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -1897,6 +1897,16 @@ config DEPRECATED_PARAM_STRUCT
>  	  This was deprecated in 2001 and announced to live on for 5 years.
>  	  Some old boot loaders still use this way.
>  
> +config XEN_DOM0
> +	def_bool y
> +
> +config XEN
> +	bool "Xen guest support on ARM (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL && ARM && OF
> +	select XEN_DOM0

   What's the point of selecting it if it's always "y"?

WBR, Sergei

