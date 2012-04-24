Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2DXQtf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 12:49:35 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45113 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab2DXQte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 12:49:34 -0400
Date: Tue, 24 Apr 2012 18:49:29 +0200
From: Borislav Petkov <bp@amd64.org>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>
Subject: Re: [PATCH] edac.h: Add generic layers for describing a memory
 location
Message-ID: <20120424164929.GW11559@aftab.osrc.amd.com>
References: <4F969FC4.9080307@redhat.com>
 <1335271799-6263-1-git-send-email-mchehab@redhat.com>
 <20120424130925.GD11559@aftab.osrc.amd.com>
 <4F96A901.6070100@redhat.com>
 <20120424133855.GJ11559@aftab.osrc.amd.com>
 <4F96D75C.1080900@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F96D75C.1080900@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 01:39:56PM -0300, Mauro Carvalho Chehab wrote:
> Ok, I'll apply then the explanation below:
> 
> diff --git a/include/linux/edac.h b/include/linux/edac.h
> index 671b27b..934c196 100644
> --- a/include/linux/edac.h
> +++ b/include/linux/edac.h
> @@ -348,7 +348,8 @@ enum edac_mc_layer_type {
>  /**
>   * struct edac_mc_layer - describes the memory controller hierarchy
>   * @layer:		layer type
> - * @size:maximum size of the layer
> + * @size:		number of components on that layer. For example,

					     per layer.

> + *			if the channel layer have two channels, size = 2

					     has

>   * @is_virt_csrow:	This layer is part of the "csrow" when old API
>   *			compatibility mode is enabled. Otherwise, it is
>   *			a channel

Ok, fair enough.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
