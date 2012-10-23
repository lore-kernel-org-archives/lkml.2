Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052Ab2JWNtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:49:18 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:32970 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756947Ab2JWNtO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:49:14 -0400
Message-ID: <1351000153.7502.44.camel@joe-AO722>
Subject: Re: [PATCH -next] printk: fix broken 'console' kernel parameter
From: Joe Perches <joe@perches.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>
Date: Tue, 23 Oct 2012 06:49:13 -0700
In-Reply-To: <1350999678-17441-1-git-send-email-ming.lei@canonical.com>
References: <1350999678-17441-1-git-send-email-ming.lei@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 21:41 +0800, Ming Lei wrote:
> If CONFIG_A11Y_BRAILLE_CONSOLE is not enabled, _braille_console_setup()
> should return NULL to parse the parameter further in console_setup().
> 
> This patch fixes the broken 'console' kernel parameter, which makes the
> Pandaboard not boot with 'console=ttyO2'.
[]
> diff --git a/kernel/printk/braille.h b/kernel/printk/braille.h
[]
> @@ -28,7 +28,7 @@ braille_set_options(struct console_cmdline *c, char *brl_options)
>  static inline char *
>  _braille_console_setup(char **str, char **brl_options)
>  {
> -	return *str;
> +	return NULL;
>  }

Thanks, I'll wait a day or two for any more reports
then repost the whole series.


