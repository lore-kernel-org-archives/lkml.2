Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2EUJTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:19:25 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54473 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757169Ab2EUJTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:19:23 -0400
MIME-Version: 1.0
In-Reply-To: <1337564348.4772.3.camel@phoenix>
References: <1337564272.4772.2.camel@phoenix>
	<1337564348.4772.3.camel@phoenix>
Date: Mon, 21 May 2012 11:19:22 +0200
Message-ID: <CACRpkdYN72T6rR1eDUyzgPt53DY0UFoP8R-tfqBUF18N3HQg7Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] regulator: ab8500: Let regulator core handle the case
 no delay for setting new voltage if regulator is off
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 3:39 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/ab8500.c |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)

Looks correct following the other patch.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Linus Walleij
