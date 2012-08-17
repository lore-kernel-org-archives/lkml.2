Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758513Ab2HQQnt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:43:49 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:49813 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab2HQQnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:43:42 -0400
MIME-Version: 1.0
In-Reply-To: <502D0859.2000602@gmail.com>
References: <502D0859.2000602@gmail.com>
Date: Fri, 17 Aug 2012 18:43:38 +0200
X-Google-Sender-Auth: ozUaKD3V87Hyv0S3sjJPH8A5xDo
Message-ID: <CAHR064gbKfpS5NO7_BJrmrUq-T1G2oz3nS3B0YGQwbT5Vn+Zdg@mail.gmail.com>
Subject: Re: [PATCH][TRIVIAL] platform/x86: fix asus_laptop.wled_type description
From: Corentin Chary <corentincj@iksaif.net>
To: Maxim Nikulin <m.a.nikulin@gmail.com>
Cc: trivial@kernel.org, acpi4asus-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 4:48 PM, Maxim Nikulin <m.a.nikulin@gmail.com> wrote:
>
> MODULE_PARM_DESC for wlan_status is further in the same file
>
> Signed-off-by: Maxim A. Nikulin <M.A.Nikulin@gmail.com>
> ---
>  drivers/platform/x86/asus-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
> index e38f91b..f5b9d91 100644
> --- a/drivers/platform/x86/asus-laptop.c
> +++ b/drivers/platform/x86/asus-laptop.c
> @@ -85,7 +85,7 @@ static char *wled_type = "unknown";
>  static char *bled_type = "unknown";
>
>  module_param(wled_type, charp, 0444);
> -MODULE_PARM_DESC(wlan_status, "Set the wled type on boot "
> +MODULE_PARM_DESC(wled_type, "Set the wled type on boot "
>                  "(unknown, led or rfkill). "
>                  "default is unknown");
>
> --
> 1.7.2.5

Acked-by: Corentin Chary <corentincj@iksaif.net>

Thanks !


-- 
Corentin Chary
http://xf.iksaif.net
