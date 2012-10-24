Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934928Ab2JXQVN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:21:13 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45189 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934276Ab2JXQVM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:21:12 -0400
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-107-git-send-email-keescook@chromium.org>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1351022666-6960-107-git-send-email-keescook@chromium.org>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <E86B2A8F-3C10-4B35-9F33-98D5A927E1E7@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kees Cook <keescook@chromium.org>, Ivo van Doorn <IvDoorn@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
X-Mailer: iPad Mail (10A403)
From: Gertjan van Wingerde <gwingerde@gmail.com>
Subject: Re: [PATCH 106/193] drivers/net/wireless/rt2x00: remove CONFIG_EXPERIMENTAL
Date: Wed, 24 Oct 2012 18:21:07 +0200
To: Kees Cook <keescook@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 23 okt. 2012, at 22:02, Kees Cook <keescook@chromium.org> wrote:

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Ivo van Doorn <IvDoorn@gmail.com>
> CC: Gertjan van Wingerde <gwingerde@gmail.com>
> CC: Helmut Schaa <helmut.schaa@googlemail.com>
> CC: "John W. Linville" <linville@tuxdriver.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>

I don't have a problem with the removal of the CONFIG_EXPERIMENTAL dependency, but I would like to retain the (EXPERIMENTAL) tag in the option string. We can then remove those tags when the support for those devices stabilize.

---
Gertjan

> ---
> drivers/net/wireless/rt2x00/Kconfig |   15 +++++----------
> 1 file changed, 5 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/wireless/rt2x00/Kconfig b/drivers/net/wireless/rt2x00/Kconfig
> index c7548da..b3d7e9a 100644
> --- a/drivers/net/wireless/rt2x00/Kconfig
> +++ b/drivers/net/wireless/rt2x00/Kconfig
> @@ -81,8 +81,7 @@ config RT2800PCI_RT33XX
>      Supported chips: RT3390
> 
> config RT2800PCI_RT35XX
> -    bool "rt2800pci - Include support for rt35xx devices (EXPERIMENTAL)"
> -    depends on EXPERIMENTAL
> +    bool "rt2800pci - Include support for rt35xx devices"
>    default y
>    ---help---
>      This adds support for rt35xx wireless chipset family to the
> @@ -91,8 +90,7 @@ config RT2800PCI_RT35XX
> 
> 
> config RT2800PCI_RT53XX
> -       bool "rt2800pci - Include support for rt53xx devices (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
> +       bool "rt2800pci - Include support for rt53xx devices"
>        default y
>        ---help---
>          This adds support for rt53xx wireless chipset family to the
> @@ -100,8 +98,7 @@ config RT2800PCI_RT53XX
>          Supported chips: RT5390
> 
> config RT2800PCI_RT3290
> -       bool "rt2800pci - Include support for rt3290 devices (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
> +       bool "rt2800pci - Include support for rt3290 devices"
>        default y
>        ---help---
>          This adds support for rt3290 wireless chipset family to the
> @@ -158,8 +155,7 @@ config RT2800USB_RT33XX
>      Supported chips: RT3370
> 
> config RT2800USB_RT35XX
> -    bool "rt2800usb - Include support for rt35xx devices (EXPERIMENTAL)"
> -    depends on EXPERIMENTAL
> +    bool "rt2800usb - Include support for rt35xx devices"
>    default y
>    ---help---
>      This adds support for rt35xx wireless chipset family to the
> @@ -167,8 +163,7 @@ config RT2800USB_RT35XX
>      Supported chips: RT3572
> 
> config RT2800USB_RT53XX
> -       bool "rt2800usb - Include support for rt53xx devices (EXPERIMENTAL)"
> -       depends on EXPERIMENTAL
> +       bool "rt2800usb - Include support for rt53xx devices"
>        ---help---
>          This adds support for rt53xx wireless chipset family to the
>          rt2800usb driver.
> -- 
> 1.7.9.5
> 
