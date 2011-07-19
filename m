Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1GST2f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 15:28:35 -0400
Received: from mail.perches.com ([173.55.12.10]:4183 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092Ab1GST2e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 15:28:34 -0400
Subject: Re: [PATCH 5/8] Staging: hv: mousevsc: Fix checkpatch errors and
 warnings
From: Joe Perches <joe@perches.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
In-Reply-To: <1311101065-23417-5-git-send-email-kys@microsoft.com>
References: <1311101018-23370-1-git-send-email-kys@microsoft.com>
	 <1311101065-23417-1-git-send-email-kys@microsoft.com>
	 <1311101065-23417-5-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 19 Jul 2011 12:28:33 -0700
Message-ID: <1311103713.12882.13.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-19 at 11:44 -0700, K. Y. Srinivasan wrote:
> Fix checkpatch errors and warnings.
[]
> diff --git a/drivers/staging/hv/hv_mouse.c b/drivers/staging/hv/hv_mouse.c
[]
> @@ -53,7 +53,7 @@ struct hv_input_dev_info {
> -#pragma pack(push,1)
> +#pragma pack(push, 1)
>  /*
>   * Message types in the synthetic input protocol
>   */

Perhaps it's better and more consistent with
other kernel style uses to remove #pragma pack[...]
and mark the individual structs with __packed;

$ grep -rP --include=*.[ch] "pragma.*pack" * | wc -l
221
$ grep -rP --include=*.[ch] "(__attribute__.*packed|\b__packed\b)" * | wc -l
5553


