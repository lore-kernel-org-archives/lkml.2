Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760967Ab2KBMml (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 08:42:41 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:42898 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520Ab2KBMmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 08:42:38 -0400
MIME-Version: 1.0
In-Reply-To: <1351858121-5708-1-git-send-email-yamanetoshi@gmail.com>
References: <1351858121-5708-1-git-send-email-yamanetoshi@gmail.com>
Date: Fri, 2 Nov 2012 13:42:37 +0100
Message-ID: <CA+MoWDosOnEdHcWQiHrVcYboAvHpKK42z36dy=mmhaV6U9WAdQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging/media: fixed spacing coding style in go7007/wis-ov7640.c
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: YAMANE Toshiaki <yamanetoshi@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>,
        linux-media <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 2, 2012 at 1:08 PM, YAMANE Toshiaki <yamanetoshi@gmail.com> wrote:
> fixed below checkpatch error.
> - ERROR: that open brace { should be on the previous line
>
> Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
Tested-by: Peter Senna Tschudin <peter.senna@gmail.com>
> ---
>  drivers/staging/media/go7007/wis-ov7640.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/staging/media/go7007/wis-ov7640.c b/drivers/staging/media/go7007/wis-ov7640.c
> index 6bc9470..eb5efc9 100644
> --- a/drivers/staging/media/go7007/wis-ov7640.c
> +++ b/drivers/staging/media/go7007/wis-ov7640.c
> @@ -29,8 +29,7 @@ struct wis_ov7640 {
>         int hue;
>  };
>
> -static u8 initial_registers[] =
> -{
> +static u8 initial_registers[] = {
>         0x12, 0x80,
>         0x12, 0x54,
>         0x14, 0x24,
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



--
Peter
