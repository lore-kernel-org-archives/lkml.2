Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758553Ab2HVIHX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 04:07:23 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:2889 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758769Ab2HVIGz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 04:06:55 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Volokh Konstantin <volokh84@gmail.com>
Subject: Re: [PATCH 04/10] staging: media: go7007: Add IDENT for TW2802/2804
Date: Wed, 22 Aug 2012 10:05:18 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc1-tschai; KDE/4.8.4; x86_64; ; )
Cc: linux-media@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, volokh@telros.ru
References: <1345632319-23224-1-git-send-email-volokh84@gmail.com> <1345632319-23224-4-git-send-email-volokh84@gmail.com>
In-Reply-To: <1345632319-23224-4-git-send-email-volokh84@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221005.18039.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed August 22 2012 12:45:13 Volokh Konstantin wrote:
> Signed-off-by: Volokh Konstantin <volokh84@gmail.com>
> ---
>  include/media/v4l2-chip-ident.h |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/include/media/v4l2-chip-ident.h b/include/media/v4l2-chip-ident.h
> index 7395c81..5395495 100644
> --- a/include/media/v4l2-chip-ident.h
> +++ b/include/media/v4l2-chip-ident.h
> @@ -113,6 +113,10 @@ enum {
>  	/* module vp27smpx: just ident 2700 */
>  	V4L2_IDENT_VP27SMPX = 2700,
>  
> +	/* module wis-tw2804: 2802/2804 */
> +	V4L2_IDENT_TW2802 = 2802,
> +	V4L2_IDENT_TW2804 = 2804,
> +
>  	/* module vpx3220: reserved range: 3210-3229 */
>  	V4L2_IDENT_VPX3214C = 3214,
>  	V4L2_IDENT_VPX3216B = 3216,
> 

There is no need to add this, unless the g/s_register or g_chip_ident ops
are also implemented.

In this case I'd just drop this patch.

Regards,

	Hans
