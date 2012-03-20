Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825Ab2CTMIa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 08:08:30 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43069 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759747Ab2CTMI2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 08:08:28 -0400
MIME-Version: 1.0
In-Reply-To: <1332209680.10843.3.camel@phoenix>
References: <1332209680.10843.3.camel@phoenix>
Date: Tue, 20 Mar 2012 13:08:28 +0100
Message-ID: <CACRpkdaUKZUo-TYB-8S92s75pUa93OwKLuHBg1AEHDySn4LOrQ@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: Convert ab3100 to set_voltage_sel
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 3:14 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/regulator/ab3100.c |   18 +++++-------------
>  1 files changed, 5 insertions(+), 13 deletions(-)

Works like a charm.
Tested-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Axel!
Linus Walleij
