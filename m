Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821Ab2DIVMI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:12:08 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52878 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab2DIVMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <1333672242.2777.8.camel@phoenix>
References: <1333671867.2777.2.camel@phoenix>
	<1333672242.2777.8.camel@phoenix>
Date: Mon, 9 Apr 2012 23:12:05 +0200
Message-ID: <CACRpkdbTkqy5ZRtzfv5XxM-4ARVWRumYXTUic7UYezsdp34AAg@mail.gmail.com>
Subject: Re: [PATCH 5/6] regulator: tps6105x: Constify regulator_desc
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 2:30 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/tps6105x-regulator.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Looks like a good idea:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks,
Linus Walleij
