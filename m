Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab1AZS16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:27:58 -0500
Received: from mail4.comsite.net ([205.238.176.238]:17436 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753720Ab1AZS15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:27:57 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
From: Milton Miller <miltonm@bga.com>
To: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC,1/5] arm/dt: Add dt machine definition
Message-Id: <lkml-patchwork-507601-use-section@mdm.bga.com>
In-Reply-To: <20110126044406.16410.22096.stgit@localhost6.localdomain6>
References: <20110126044406.16410.22096.stgit@localhost6.localdomain6>
Cc: devicetree-discuss@lists.ozlabs.org, jeremy.kerr@canonical.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.orga,
        nicolas.pitre@linaro.org
Date: Wed, 26 Jan 2011 12:27:50 -0600
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Jan 2011 about 04:44:06 -0000, Grant Likely wrote:
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

needs a description ...
> 
> ---
> arch/arm/include/asm/mach/arch.h |    9 +++++++++
>  1 files changed, 9 insertions(+), 0 deletions(-)
> 
> 
>  
> +#define MACH_TYPE_DT	0xffffffff
> +
> +#define DT_MACHINE_START(_name, _namestr)		\
> +static const struct machine_desc __mach_desc_##_name	\
> + __used							\
> + __attribute__((__section__(".arch.info.init"))) = {	\

linux/compiler.h defines __section for this

> +	.nr		= MACH_TYPE_DT,			\
> +	.name		= _namestr,
> +
>  #endif

milton
