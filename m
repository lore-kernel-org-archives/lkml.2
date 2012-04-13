Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab2DMMod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 08:44:33 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56373 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932119Ab2DMMob convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 08:44:31 -0400
MIME-Version: 1.0
In-Reply-To: <1334184346-16377-2-git-send-email-swarren@wwwdotorg.org>
References: <1334184346-16377-1-git-send-email-swarren@wwwdotorg.org>
	<1334184346-16377-2-git-send-email-swarren@wwwdotorg.org>
Date: Fri, 13 Apr 2012 14:44:30 +0200
Message-ID: <CACRpkdaVqsek-ZFn-AUJ0B-fkODqAsv1j=GJfx3JHvvxv7oO9g@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: allow pctldevs to decode pin config in debugfs
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 12:45 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> diff --git a/include/linux/pinctrl/pinconf.h b/include/linux/pinctrl/pinconf.h
> index ec431f0..5e37de2 100644
> --- a/include/linux/pinctrl/pinconf.h
> +++ b/include/linux/pinctrl/pinconf.h
> @@ -56,6 +56,9 @@ struct pinconf_ops {
>        void (*pin_config_group_dbg_show) (struct pinctrl_dev *pctldev,
>                                           struct seq_file *s,
>                                           unsigned selector);
> +       void (*pin_config_config_dbg_show) (struct pinctrl_dev *pctldev,
> +                                           struct seq_file *s,
> +                                           unsigned long config);
>  };

Please update the kerneldoc for pinconf_ops and I'll apply.

Yours,
Linus Walleij
