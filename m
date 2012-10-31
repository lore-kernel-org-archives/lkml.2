Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422921Ab2JaNwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:52:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50733 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422848Ab2JaNv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:51:59 -0400
Date: Wed, 31 Oct 2012 14:51:54 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?David_H=E4rdeman?= <david@hardeman.nu>
Cc: mchehab@infradead.org, sfr@canb.auug.org.au, bonbons@linux-vserver.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hid-picolcd_cir: fix compilation
In-Reply-To: <20121031082208.7522.22716.stgit@zeus.hardeman.nu>
Message-ID: <alpine.LNX.2.00.1210311451340.12781@pobox.suse.cz>
References: <20121031082208.7522.22716.stgit@zeus.hardeman.nu>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, David Härdeman wrote:

> Commit c003ab1bedf0 ("[media] rc-core: add separate defines for
> protocol bitmaps and numbers") overlooked hid-picolcd.
> 
> This patch (against git.linuxtv.org/media_tree.git, branch
> staging/for_v3.8) fixes the compilation breakage.
> 
> Signed-off-by: David Härdeman <david@hardeman.nu>
> ---
>  drivers/hid/hid-picolcd_cir.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-picolcd_cir.c b/drivers/hid/hid-picolcd_cir.c
> index 13ca919..a79e95b 100644
> --- a/drivers/hid/hid-picolcd_cir.c
> +++ b/drivers/hid/hid-picolcd_cir.c
> @@ -116,7 +116,7 @@ int picolcd_init_cir(struct picolcd_data *data, struct hid_report *report)
>  
>  	rdev->priv             = data;
>  	rdev->driver_type      = RC_DRIVER_IR_RAW;
> -	rdev->allowed_protos   = RC_TYPE_ALL;
> +	rdev->allowed_protos   = RC_BIT_ALL;
>  	rdev->open             = picolcd_cir_open;
>  	rdev->close            = picolcd_cir_close;
>  	rdev->input_name       = data->hdev->name;

This has been reported by Stephen a few days ago already ... Mauro, any 
plans to have that fixed up in media tree please?

Thanks,

-- 
Jiri Kosina
SUSE Labs
