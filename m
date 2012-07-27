Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab2G0Wp0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:45:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42778 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab2G0WpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:45:25 -0400
MIME-Version: 1.0
In-Reply-To: <1342603220-13287-2-git-send-email-peter.ujfalusi@ti.com>
References: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
	<1342603220-13287-2-git-send-email-peter.ujfalusi@ti.com>
Date: Sat, 28 Jul 2012 00:45:24 +0200
Message-ID: <CACRpkdaOmCe05NF2d5-1xqx7UmY80LTZXJG_Lj6rnFqyk_OvHg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: twl6040: Fix GPO mask
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 11:20 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

>  #define TWL6040_GPO1                   0x01
>  #define TWL6040_GPO2                   0x02
> -#define TWL6040_GPO3                   0x03
> +#define TWL6040_GPO3                   0x04

Maybe a stupid question but does these register defines really belong in that
header file? Can't you do a separate patch moving them into the driver per
se?

Yours,
Linus Walleij
