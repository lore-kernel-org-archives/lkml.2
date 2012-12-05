Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab2LEW2a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:28:30 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47880 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab2LEW22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:28:28 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 06/44] of/vendor-prefixes: add Imagination Technologies
To: James Hogan <james.hogan@imgtec.com>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, James Hogan <james.hogan@imgtec.com>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org
In-Reply-To: <1354723742-6195-7-git-send-email-james.hogan@imgtec.com>
References: <1354723742-6195-1-git-send-email-james.hogan@imgtec.com> <1354723742-6195-7-git-send-email-james.hogan@imgtec.com>
Date: Wed, 05 Dec 2012 22:28:23 +0000
Message-Id: <20121205222824.005C53E0E22@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012 16:08:24 +0000, James Hogan <james.hogan@imgtec.com> wrote:
> The "powervr" prefix which is currently described as "Imagination
> Technologies" isn't really appropriate for non-PowerVR hardware, so
> deprecate it, changing the description of "powervr" to "PowerVR
> (deprecated, use img)", and add a separate "img" prefix for "Imagination
> Technologies Ltd.".
> 
> Signed-off-by: James Hogan <james.hogan@imgtec.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Rob Landley <rob@landley.net>
> Cc: devicetree-discuss@lists.ozlabs.org

Applied, thanks.

g.

> ---
>  .../devicetree/bindings/vendor-prefixes.txt        |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 9de2b9f..aab2993 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -25,6 +25,7 @@ gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
>  hp	Hewlett Packard
>  ibm	International Business Machines (IBM)
>  idt	Integrated Device Technologies, Inc.
> +img	Imagination Technologies Ltd.
>  intercontrol	Inter Control Group
>  linux	Linux-specific binding
>  marvell	Marvell Technology Group Ltd.
> @@ -35,7 +36,7 @@ nintendo	Nintendo
>  nvidia	NVIDIA
>  nxp	NXP Semiconductors
>  picochip	Picochip Ltd
> -powervr	Imagination Technologies
> +powervr	PowerVR (deprecated, use img)
>  qcom	Qualcomm, Inc.
>  ramtron	Ramtron International
>  realtek Realtek Semiconductor Corp.
> -- 
> 1.7.7.6
> 
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
