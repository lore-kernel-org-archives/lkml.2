Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab1ABOph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 09:45:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34752 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab1ABOpf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 09:45:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iSsMvf5m5RaSqBSO/q3VLLjrP/qJIoHm/oqOYFWZ6aStR0nazgAHV6bolPyAhPqOKF
         G0AFtzLyixuJd8mDE35iV1LELks2CpIrpq6FY+TQgAe2BBSATLrWaRXA/ywV8GKGjYGZ
         HBx+njYEcOFJcfWctOjRAJi+l1mI5lN0S0WOM=
MIME-Version: 1.0
In-Reply-To: <1293978109-5288-1-git-send-email-weil@mail.berlios.de>
References: <1293978109-5288-1-git-send-email-weil@mail.berlios.de>
Date: Sun, 2 Jan 2011 15:45:34 +0100
X-Google-Sender-Auth: 05npOoSHEm-XBz5r7-B-MZCbtHQ
Message-ID: <AANLkTimZs7d6NtNST7rN6rrdAqmnFyf9nEJDTZ5Nb4Bm@mail.gmail.com>
Subject: Re: [PATCH] Fix spelling milisec -> ms in module parameter description
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Stefan Weil <weil@mail.berlios.de>
Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
        Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Geoff Levand <geoff@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 2, 2011 at 15:21, Stefan Weil <weil@mail.berlios.de> wrote:
> Instead of replacing 'milisec' by 'millisec', I decided to use
> the more common SI unit. Other drivers use 'milliseconds'
> or 'ms', too ('millisec' is never used).
>
> Cc: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> Cc: Jiri Kosina <trivial@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  sound/ppc/snd_ps3.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/sound/ppc/snd_ps3.c b/sound/ppc/snd_ps3.c
> index 581a670..edce8a2 100644
> --- a/sound/ppc/snd_ps3.c
> +++ b/sound/ppc/snd_ps3.c
> @@ -51,7 +51,7 @@ static struct snd_ps3_card_info the_card;
>  static int snd_ps3_start_delay = CONFIG_SND_PS3_DEFAULT_START_DELAY;
>
>  module_param_named(start_delay, snd_ps3_start_delay, uint, 0644);
> -MODULE_PARM_DESC(start_delay, "time to insert silent data in milisec");
> +MODULE_PARM_DESC(start_delay, "time to insert silent data in ms");
>
>  static int index = SNDRV_DEFAULT_IDX1;
>  static char *id = SNDRV_DEFAULT_STR1;
> --
> 1.7.2.3

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
