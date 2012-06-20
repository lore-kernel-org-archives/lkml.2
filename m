Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755613Ab2FTIAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:00:50 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:33249 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab2FTIAr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:00:47 -0400
MIME-Version: 1.0
In-Reply-To: <1340041638-30233-1-git-send-email-devendra.aaru@gmail.com>
References: <1340041638-30233-1-git-send-email-devendra.aaru@gmail.com>
Date: Wed, 20 Jun 2012 10:00:46 +0200
Message-ID: <CACRpkdYGDz40b4ayvz620=ZzMmArJR-bq1Ah8kWAc+3VjnkSQQ@mail.gmail.com>
Subject: Re: [PATCH] pinctrl/pinctrl-u300: remove unused variable i
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 7:47 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> the unused variable warning was thrown when compiled using the
> gcc for ARM (arm-linux-gnueabihf-gcc) with u300_defconfig selected,
>
> make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- u300_defconfig
>
> and then
>
> make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf-
>
> gives the following warn,
>
> drivers/pinctrl/pinctrl-u300.c: In function ‘u300_pmx_remove’:
> drivers/pinctrl/pinctrl-u300.c:1178:6: warning: unused variable ‘i’ [-Wunused-variable]
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Incidentally I was working on this code and fixed the same issue,
but thanks anyway!

Yours,
Linus Walleij
