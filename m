Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab2FXNJg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 09:09:36 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:40492 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab2FXNJf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 09:09:35 -0400
MIME-Version: 1.0
In-Reply-To: <1340492074-13664-2-git-send-email-anatol.pomozov@gmail.com>
References: <1340492074-13664-1-git-send-email-anatol.pomozov@gmail.com> <1340492074-13664-2-git-send-email-anatol.pomozov@gmail.com>
From: Jimmy Pan <dspjmt@gmail.com>
Date: Sun, 24 Jun 2012 21:09:13 +0800
Message-ID: <CAGTyHCpSa8hSuiBS53t9GuXfv6v_AYbCv8Wn=snHqiG1HHtbRA@mail.gmail.com>
Subject: Re: [PATCH] Fix typo in printed messages
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2012 at 6:54 AM, Anatol Pomozov
<anatol.pomozov@gmail.com> wrote:
> Coult -> Could
> ---
>  arch/sparc/kernel/vio.c               |    2 +-
>  drivers/net/wireless/b43/main.c       |    2 +-
>  drivers/net/wireless/b43legacy/main.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/arch/sparc/kernel/vio.c b/arch/sparc/kernel/vio.c
> index 5cffdc5..3e244f3 100644
> --- a/arch/sparc/kernel/vio.c
> +++ b/arch/sparc/kernel/vio.c
> @@ -443,7 +443,7 @@ static int __init vio_init(void)
>        root_vdev = vio_create_one(hp, root, NULL);
>        err = -ENODEV;
>        if (!root_vdev) {
> -               printk(KERN_ERR "VIO: Coult not create root device.\n");
> +               printk(KERN_ERR "VIO: Could not create root device.\n");
>                goto out_release;
>        }
>
> diff --git a/drivers/net/wireless/b43/main.c
> b/drivers/net/wireless/b43/main.c
> index acd03a4..1b988f2 100644
> --- a/drivers/net/wireless/b43/main.c
> +++ b/drivers/net/wireless/b43/main.c
> @@ -3767,7 +3767,7 @@ static int b43_switch_band(struct b43_wl *wl, struct
> ieee80211_channel *chan)
>        if (prev_status >= B43_STAT_STARTED) {
>                err = b43_wireless_core_start(up_dev);
>                if (err) {
> -                       b43err(wl, "Fatal: Coult not start device for "
> +                       b43err(wl, "Fatal: Could not start device for "
>                               "selected %s-GHz band\n",
>                               band_to_string(chan->band));
>                        b43_wireless_core_exit(up_dev);
> diff --git a/drivers/net/wireless/b43legacy/main.c
> b/drivers/net/wireless/b43legacy/main.c
> index cd9c9bc..eae691e 100644
> --- a/drivers/net/wireless/b43legacy/main.c
> +++ b/drivers/net/wireless/b43legacy/main.c
> @@ -2633,7 +2633,7 @@ static int b43legacy_switch_phymode(struct
> b43legacy_wl *wl,
>        if (prev_status >= B43legacy_STAT_STARTED) {
>                err = b43legacy_wireless_core_start(up_dev);
>                if (err) {
> -                       b43legacyerr(wl, "Fatal: Coult not start device
> for "
> +                       b43legacyerr(wl, "Fatal: Could not start device
> for "
>                               "newly selected %s-PHY mode\n",
>                               phymode_to_string(new_mode));
>                        b43legacy_wireless_core_exit(up_dev);
> --
> 1.7.9.5
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


With no offense, I am a newbie too. I wonder if we need such kind of refinement.
