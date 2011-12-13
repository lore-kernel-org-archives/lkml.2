Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753635Ab1LMMjg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 07:39:36 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63184 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660Ab1LMMjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 07:39:35 -0500
MIME-Version: 1.0
In-Reply-To: <1323757911-25217-4-git-send-email-eric@eukrea.com>
References: <1323757911-25217-1-git-send-email-eric@eukrea.com>
	<1323757911-25217-4-git-send-email-eric@eukrea.com>
Date: Tue, 13 Dec 2011 10:39:34 -0200
Message-ID: <CAOMZO5AcFUVJ171JYU434pAiJ5s232BTy26CPqh_2zQ2zQu53Q@mail.gmail.com>
Subject: Re: [PATCH 04/19] mbimxsd25: add spi controler and spidev support
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Sascha Hauer <kernel@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 4:31 AM, Eric Bénard <eric@eukrea.com> wrote:

> +#define        GPIO_SPI1_IRQ   IMX_GPIO_NR(2, 22)

I don't see where this is used.

Regards,

Fabio Estevam
