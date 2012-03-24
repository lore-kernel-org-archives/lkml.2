Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755356Ab2CYAbk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 20:31:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:63036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab2CYAbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 20:31:11 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] powerpc/44x: Support CPM for Maui APM821xxx SoC and Bluestone board
To: Mai La <mla@apm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Tirumala R Marri <tmarri@apm.com>, Michael Neuling <mikey@neuling.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Cc: Mai La <mla@apm.com>
In-Reply-To: <1332296472-24734-1-git-send-email-mla@apm.com>
References: <1332296472-24734-1-git-send-email-mla@apm.com>
Date: Sat, 24 Mar 2012 12:48:30 -0700
Message-Id: <20120324194830.5CE563E0B34@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 09:21:12 +0700, Mai La <mla@apm.com> wrote:
> In this patch:
> - Add CPM node for Maui APM821xxx SoC and Bluestone board in DTS
> 
> Signed-off-by: Mai La <mla@apm.com>
> ---
>  arch/powerpc/boot/dts/bluestone.dts |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/powerpc/boot/dts/bluestone.dts b/arch/powerpc/boot/dts/bluestone.dts
> index 2a56a0d..15a9516 100644
> --- a/arch/powerpc/boot/dts/bluestone.dts
> +++ b/arch/powerpc/boot/dts/bluestone.dts
> @@ -117,6 +117,15 @@
>  		dcr-reg = <0x00c 0x002>;
>  	};
>  
> +	CPM0: cpm {
> +		compatible = "ibm, cpm-apm821xx", "ibm,cpm";
                                  ^
Is that a typo?

> +		cell-index = <0>;
> +		dcr-reg = <0x160 0x003>;
> +		er-offset = <0>;
> +		idle-doze = <0x02000000>;
> +		standby = <0x302570F0>;
> +	};
> +
>  	plb {
>  		compatible = "ibm,plb4";
>  		#address-cells = <2>;
> -- 
> 1.7.3.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies,Ltd.
