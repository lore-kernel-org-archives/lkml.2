Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab2BCAG4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:06:56 -0500
Received: from mail-lpp01m020-f174.google.com ([209.85.217.174]:50701 "EHLO
	mail-lpp01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307Ab2BCAGy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:06:54 -0500
MIME-Version: 1.0
In-Reply-To: <1327960820-11867-7-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
	<1327960820-11867-7-git-send-email-danny.kukawka@bisect.de>
Date: Thu, 2 Feb 2012 19:06:52 -0500
X-Google-Sender-Auth: Oltd62Op7Ttzv3G2oUf2l2tM6q8
Message-ID: <CAO8r2eeSPQnCR4KkZyrZA8LtsZY3nnsNHYynBC0Rc8N-02fihQ@mail.gmail.com>
Subject: Re: [PATCH 06/16] cpcihp: fix debug module parameter to be bool
From: Scott Murray <scott@spiteful.org>
To: Danny Kukawka <danny.kukawka@bisect.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, this looks fine.

Acked-by: Scott Murray <scott@spiteful.org>

On Mon, Jan 30, 2012 at 5:00 PM, Danny Kukawka <danny.kukawka@bisect.de> wrote:
>
> Fix debug variable from module parameter to be really bool to
> fix 'warning: return from incompatible pointer type'.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
> ---
>  drivers/pci/hotplug/cpcihp_generic.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/pci/hotplug/cpcihp_generic.c b/drivers/pci/hotplug/cpcihp_generic.c
> index fb3f846..81af764 100644
> --- a/drivers/pci/hotplug/cpcihp_generic.c
> +++ b/drivers/pci/hotplug/cpcihp_generic.c
> @@ -62,7 +62,7 @@
>  #define warn(format, arg...) printk(KERN_WARNING "%s: " format "\n", MY_NAME , ## arg)
>
>  /* local variables */
> -static int debug;
> +static bool debug;
>  static char *bridge;
>  static u8 bridge_busnr;
>  static u8 bridge_slot;
> --
> 1.7.7.3
>
