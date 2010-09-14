Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752914Ab0INHhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 03:37:42 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38817 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0INHhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 03:37:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=DjrhVzs4Te38NtRwZqpN6D29xLkXAZzwPGaYBAwZRYwVw+0SOc+pWIq+EUcK26ZOv3
         UXIhze9WxYsEw7e/ofuVNYpQYTIUFzT7FpgO7WY6B5atMT5/FjsZZqd5gB6o/uWznh31
         mtrBYYin+0Z6H4gpeBFdY9H7pa//3AqQgF/o4=
MIME-Version: 1.0
In-Reply-To: <78519236782f0f4a848d67aefb5fe7b3ce375cee.1284267142.git.joe@perches.com>
References: <cover.1284267142.git.joe@perches.com> <78519236782f0f4a848d67aefb5fe7b3ce375cee.1284267142.git.joe@perches.com>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Tue, 14 Sep 2010 15:37:20 +0800
Message-ID: <AANLkTinmZbhre05GNcqOh1Sqv+vaN1MqLo4X7dGYuALO@mail.gmail.com>
Subject: Re: [PATCH 01/11] arch/arm: Remove pr_<level> uses of KERN_<level>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 1:10 PM, Joe Perches <joe@perches.com> wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Applied to 'fix', with a little bit modification to the subject line to follow
ARM patch title conventions.

> ---
>  arch/arm/mach-pxa/cpufreq-pxa2xx.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-pxa/cpufreq-pxa2xx.c b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
> index 50d5939..58093d9 100644
> --- a/arch/arm/mach-pxa/cpufreq-pxa2xx.c
> +++ b/arch/arm/mach-pxa/cpufreq-pxa2xx.c
> @@ -312,8 +312,7 @@ static int pxa_set_target(struct cpufreq_policy *policy,
>        freqs.cpu = policy->cpu;
>
>        if (freq_debug)
> -               pr_debug(KERN_INFO "Changing CPU frequency to %d Mhz, "
> -                        "(SDRAM %d Mhz)\n",
> +               pr_debug("Changing CPU frequency to %d Mhz, (SDRAM %d Mhz)\n",
>                         freqs.new / 1000, (pxa_freq_settings[idx].div2) ?
>                         (new_freq_mem / 2000) : (new_freq_mem / 1000));
>
> --
> 1.7.3.rc1
>
>
