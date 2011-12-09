Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752372Ab1LIIZk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 03:25:40 -0500
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:23210
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752087Ab1LIIZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 03:25:39 -0500
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:137.71.25.57;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta2.analog.com;RD:nwd2mail11.analog.com;EFVD:NLI
Message-ID: <4EE1C3F4.6020108@analog.com>
Date: Fri, 9 Dec 2011 09:16:52 +0100
From: Michael Hennerich <michael.hennerich@analog.com>
Reply-To: <michael.hennerich@analog.com>
Organization: Analog Devices Inc.
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>
Subject: Re: [PATCH v3.2 03/10] MAINTAINERS: Update adp gpio F: patterns
References: <cover.1323401278.git.joe@perches.com> <752ff6829eee7b258b3fd7de0a07c9f035fcf1f4.1323401278.git.joe@perches.com>
In-Reply-To: <752ff6829eee7b258b3fd7de0a07c9f035fcf1f4.1323401278.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2011 05:21 AM, Joe Perches wrote:
> Commit c103de240439df ("gpio: reorganize drivers") renamed
> the files, update the patterns.
>
> CC: Grant Likely<grant.likely@secretlab.ca>
> CC: Michael Hennerich<michael.hennerich@analog.com>
>
> Signed-off-by: Joe Perches<joe@perches.com>
Acked-by: Michael Hennerich <michael.hennerich@analog.com>
> ---
>   MAINTAINERS |    4 ++--
>   1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 80167e7..bfa54c1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -347,7 +347,7 @@ S:	Supported
>   F:	drivers/mfd/adp5520.c
>   F:	drivers/video/backlight/adp5520_bl.c
>   F:	drivers/leds/leds-adp5520.c
> -F:	drivers/gpio/adp5520-gpio.c
> +F:	drivers/gpio/gpio-adp5520.c
>   F:	drivers/input/keyboard/adp5520-keys.c
>
>   ADP5588 QWERTY KEYPAD AND IO EXPANDER DRIVER (ADP5588/ADP5587)
> @@ -356,7 +356,7 @@ L:	device-drivers-devel@blackfin.uclinux.org
>   W:	http://wiki.analog.com/ADP5588
>   S:	Supported
>   F:	drivers/input/keyboard/adp5588-keys.c
> -F:	drivers/gpio/adp5588-gpio.c
> +F:	drivers/gpio/gpio-adp5588.c
>
>   ADP8860 BACKLIGHT DRIVER (ADP8860/ADP8861/ADP8863)
>   M:	Michael Hennerich<michael.hennerich@analog.com>


-- 
Greetings,
Michael

--
Analog Devices GmbH      Wilhelm-Wagenfeld-Str. 6      80807 Muenchen
Sitz der Gesellschaft: Muenchen; Registergericht: Muenchen HRB 40368;
Geschaeftsfuehrer:Dr.Carsten Suckrow, Thomas Wessel, William A. Martin,
Margaret Seif


