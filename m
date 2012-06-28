Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753179Ab2F1QA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:00:28 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:60337 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab2F1QA0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:00:26 -0400
MIME-Version: 1.0
In-Reply-To: <1340232467-6023-9-git-send-email-john.stultz@linaro.org>
References: <1340232467-6023-1-git-send-email-john.stultz@linaro.org>
	<1340232467-6023-9-git-send-email-john.stultz@linaro.org>
Date: Thu, 28 Jun 2012 18:00:25 +0200
Message-ID: <CACRpkdagTWL6=yGzrirPLCiKybXUvdRo-sjP7SdGVafFL8EYhA@mail.gmail.com>
Subject: Re: [PATCH 08/15] ARM: etm: Support multiple ETMs/PTMs.
From: Linus Walleij <linus.walleij@linaro.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Russell King <linux@arm.linux.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 12:47 AM, John Stultz <john.stultz@linaro.org> wrote:

> From: Arve Hjønnevåg <arve@android.com>
>
> If more than one ETM or PTM are present, configure all of them
> and enable the formatter in the ETB. This allows tracing on dual
> core systems (e.g. omap4).
>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Paul Gortmaker <paul.gortmaker@windriver.com>
> CC: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

> @@ -753,6 +827,10 @@ static struct amba_id etm_ids[] = {
>                .id     = 0x0003b921,
>                .mask   = 0x0007ffff,
>        },
> +       {
> +               .id     = 0x0003b950,
> +               .mask   = 0x0007ffff,
> +       },

Add some blurb to the commit that there is a newer version of the
ETM called PTM that has this ID (or whatever that thing is, I suspect
that's the ID of a PTM?)

Yours,
Linus Walleij
