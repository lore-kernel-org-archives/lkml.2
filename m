Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab2DCUrR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:47:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51870 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754182Ab2DCUrQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:47:16 -0400
MIME-Version: 1.0
In-Reply-To: <1333137905-13809-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20120330200358.GV15647@pengutronix.de>
	<1333137905-13809-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Tue, 3 Apr 2012 22:47:16 +0200
Message-ID: <CACRpkdZDZXbiUDrZjSfhAquAkRyTohFNgQrqp4SME=bKv8PiUA@mail.gmail.com>
Subject: Re: [PATCH v2 01/15] pinctrl: mark const init data with __initconst
 instead of __initdata
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        kernel@pengutronix.de, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/30 Uwe Kleine-König <u.kleine-koenig@pengutronix.de>:

> changes since (implict) v1:
>  - move __initconst after variable name

Bah, applied this instead of v1.

Thanks,
Linus Walleij
