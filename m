Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab0GHIoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 04:44:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:51790 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab0GHIoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 04:44:08 -0400
Date: Thu, 8 Jul 2010 10:34:42 +0200
From: Anisse Astier <anisse@astier.eu>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg@redhat.com>, Thomas Renninger <trenn@suse.de>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH] msi-wmi: make needlessly global symbols static
Message-ID: <20100708103442.28520f6f@destiny.ordissimo>
In-Reply-To: <1278553830.7162.9.camel@mola>
References: <1278553830.7162.9.camel@mola>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Axel,

On Thu, 08 Jul 2010 09:50:30 +0800, Axel Lin <axel.lin@gmail.com> wrote :

> backlight is needlessly defined global.
> This patch makes the symbol static.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Acked-by: Anisse Astier <anisse@astier.eu>

Thanks,

Anisse

> ---
>  drivers/platform/x86/msi-wmi.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
> index d173600..42a5469 100644
> --- a/drivers/platform/x86/msi-wmi.c
> +++ b/drivers/platform/x86/msi-wmi.c
> @@ -57,7 +57,7 @@ static struct key_entry msi_wmi_keymap[] = {
>  };
>  static ktime_t last_pressed[ARRAY_SIZE(msi_wmi_keymap) - 1];
>  
> -struct backlight_device *backlight;
> +static struct backlight_device *backlight;
>  
>  static int backlight_map[] = { 0x00, 0x33, 0x66, 0x99, 0xCC, 0xFF };
>  
