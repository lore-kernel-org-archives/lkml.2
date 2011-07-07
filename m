Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533Ab1GGAeb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:34:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:50544 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666Ab1GGAe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:34:29 -0400
MIME-Version: 1.0
In-Reply-To: <e9742e1fca57477517fdb6ea110221d6292eed9c.1309997525.git.joe@perches.com>
References: <e9742e1fca57477517fdb6ea110221d6292eed9c.1309997525.git.joe@perches.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 6 Jul 2011 18:34:08 -0600
X-Google-Sender-Auth: m7zNOEzU5lJOKg8LiyNRx8p4fUI
Message-ID: <CACxGe6uRmgWBN0H6hrYBik_q7B2NxP0kny3cpH9xEA5wPZLEtw@mail.gmail.com>
Subject: Re: [PATCH next 1/2] MAINTAINERS: Update GPIO sections patterns
To: Joe Perches <joe@perches.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Michael Buesch <mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 6, 2011 at 6:28 PM, Joe Perches <joe@perches.com> wrote:
> commit c103de24043 ("gpio: reorganize drivers")
> renamed the files, update the patterns.
>
> cc: Grant Likely <grant.likely@secretlab.ca>
> cc: Michael Hennerich <michael.hennerich@analog.com>
> cc: Michael Buesch <mb@bu3sch.de>
>
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Grant Likely <grant.likely@secretlab.ca>
> ---
>  MAINTAINERS |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 657fabe..0ad8ff0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -343,7 +343,7 @@ S:  Supported
>  F:     drivers/mfd/adp5520.c
>  F:     drivers/video/backlight/adp5520_bl.c
>  F:     drivers/leds/leds-adp5520.c
> -F:     drivers/gpio/adp5520-gpio.c
> +F:     drivers/gpio/gpio-adp5520.c
>  F:     drivers/input/keyboard/adp5520-keys.c
>
>  ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
> @@ -352,7 +352,7 @@ L:  device-drivers-devel@blackfin.uclinux.org
>  W:     http://wiki.analog.com/ADP5588
>  S:     Supported
>  F:     drivers/input/keyboard/adp5588-keys.c
> -F:     drivers/gpio/adp5588-gpio.c
> +F:     drivers/gpio/gpio-adp5588.c
>
>  ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
>  M:     Michael Hennerich <michael.hennerich@analog.com>
> @@ -1587,11 +1587,11 @@ S:      Maintained
>  F:     Documentation/sound/alsa/Bt87x.txt
>  F:     sound/pci/bt87x.c
>
> -BT8XXGPIO DRIVER
> +BT8XX GPIO DRIVER
>  M:     Michael Buesch <mb@bu3sch.de>
>  W:     http://bu3sch.de/btgpio.php
>  S:     Maintained
> -F:     drivers/gpio/bt8xxgpio.c
> +F:     drivers/gpio/gpio-bt8xx.c
>
>  BTRFS FILE SYSTEM
>  M:     Chris Mason <chris.mason@oracle.com>
> --
> 1.7.6.131.g99019
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
