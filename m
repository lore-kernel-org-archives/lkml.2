Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab2HFBw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2012 21:52:59 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62461 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286Ab2HFBw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2012 21:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <CAGh4K3LLy0fnFMJ-e+yqCM7cpONo41-cP_o7dQvsAesd-hdvuQ@mail.gmail.com>
References: <CAGh4K3LLy0fnFMJ-e+yqCM7cpONo41-cP_o7dQvsAesd-hdvuQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 6 Aug 2012 11:52:36 +1000
Message-ID: <CAGRGNgUrwCF6arte70Yrifeeq7wZB+hjGnwG4wBfT8zOgghZBg@mail.gmail.com>
Subject: Re: [PATCH]: With no attatchment NOT SPAM, a REWRITE
To: Christopher Sacchi <chris.sacchi@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christopher,

On Mon, Aug 6, 2012 at 11:01 AM, Christopher Sacchi
<chris.sacchi@gmail.com> wrote:
> Hey guys, this should work now.

I see the changes you made, however you're not going to get them
accepted in this format.

See Documentation/SubmittingPatches

Online here: https://git.kernel.org/?p=linux/kernel/git/linville/wireless-testing.git;a=blob;f=Documentation/SubmittingPatches;h=c379a2a6949f1c1cac04fb6f185c633512f37061;hb=HEAD



> --
> --- main.c      2012-07-21 20:58:29.000000000 +0000
> +++ mainnew.c   2012-08-05 20:00:37.000000000 +0000
> @@ -32,7 +32,7 @@
>  #include "led.h"
>  #include "cfg.h"
>  #include "debugfs.h"
> -

Why are you removing the blank line - it's required as part of the
kernel coding style.

> +#include "net/rfkill/rfkill.h"

You don't seem to actually be adding any code that uses anything in
this header and don't explain why it's needed.

>  static struct lock_class_key ieee80211_rx_skb_queue_class;
>
>  void ieee80211_configure_filter(struct ieee80211_local *local)
> @@ -183,6 +183,7 @@
>                  *
>                  */
>                 /* WARN_ON(ret); */
> +               WARN_ON(1)

What bug is this fixing? What problem is this solving?

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
