Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752497Ab0LLBpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 20:45:21 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46463 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab0LLBpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 20:45:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=nDuDC/y7eQtuEI+4/2C1Cj0zUVfRApcijE4WYUxHH2jqU+n+heKYAVFHOZ/ZgiSsFE
         r21inLhFV7q9tJA9EiT0thYcf4alNKGRovIrSMx+nZBEn8UtgSHOW8I1BJvX+5vaeY2B
         aKcwXeoHrajXcz+rvqCXU0204//AyXBa0lGyo=
MIME-Version: 1.0
In-Reply-To: <1292086701-7509-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1292086701-7509-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: Cory Maccarrone <darkstar6262@gmail.com>
Date: Sat, 11 Dec 2010 17:44:58 -0800
Message-ID: <AANLkTinqv=7oB2pH=p8bLJqWqXjGK4xaedte1tonGp8Z@mail.gmail.com>
Subject: Re: [PATCH 6/7] mfd: Convert HTC I2C CPLD driver to irq_ API
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Paul Mundt <lethal@linux-sh.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 11, 2010 at 8:58 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> The genirq core is being converted to pass a struct irq_data to interrupt
> operations rather than an IRQ number.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/htc-i2cpld.c |   30 +++++++++++++++---------------
>  1 files changed, 15 insertions(+), 15 deletions(-)
>

Looks good, and works perfectly.  Thanks!

Signed-off-by: Cory Maccarrone <darkstar6262@gmail.com>

- Cory
