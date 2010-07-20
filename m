Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932204Ab0GTPO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 11:14:56 -0400
Received: from cantor.suse.de ([195.135.220.2]:33710 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760904Ab0GTPOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 11:14:54 -0400
Date: Tue, 20 Jul 2010 17:14:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, Eric Anholt <eric@anholt.net>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhao Yakui <yakui.zhao@intel.com>, Ma Ling <ling.ma@intel.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/16] trivial: use ARRAY_SIZE
In-Reply-To: <1277726101-24567-1-git-send-email-segooon@gmail.com>
Message-ID: <alpine.LNX.2.00.1007201714380.4741@pobox.suse.cz>
References: <1277726101-24567-1-git-send-email-segooon@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jun 2010, Kulikov Vasiliy wrote:

> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/gpu/drm/i915/intel_tv.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/gpu/drm/i915/intel_tv.c b/drivers/gpu/drm/i915/intel_tv.c
> index 6d553c2..d2d4e40 100644
> --- a/drivers/gpu/drm/i915/intel_tv.c
> +++ b/drivers/gpu/drm/i915/intel_tv.c
> @@ -1424,7 +1424,7 @@ intel_tv_get_modes(struct drm_connector *connector)
>  	int j, count = 0;
>  	u64 tmp;
>  
> -	for (j = 0; j < sizeof(input_res_table) / sizeof(input_res_table[0]);
> +	for (j = 0; j < ARRAY_SIZE(input_res_table);
>  	     j++) {
>  		struct input_res *input = &input_res_table[j];

Folded into the sdvo change you did and applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
