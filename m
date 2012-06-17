Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab2FQOcb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 10:32:31 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:36283 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab2FQOca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 10:32:30 -0400
X-Greylist: delayed 457 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Jun 2012 10:32:30 EDT
MIME-Version: 1.0
In-Reply-To: <1339122469.5794.2.camel@phoenix>
References: <1339122469.5794.2.camel@phoenix>
Date: Sun, 17 Jun 2012 16:24:52 +0200
Message-ID: <CACRpkdaUVMp+VstcSsWCQ-5Oe8QwcQL5Rt41Xm7kR2parUDgVQ@mail.gmail.com>
Subject: Re: [PATCH RFT 1/2] regulator: ab8500: Use regulator_list_voltage_linear
 for ab8500_regulator_fixed_ops
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 8, 2012 at 4:27 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Also removes set_voltage_time_sel callback from ab8500_regulator_fixed_ops
> because the voltage won't change. ( And ab8500_regulator_fixed_ops does not
> implement get_voltage_sel so set_voltage_time_sel won't be called )
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

I cannot test this either, it does not apply cleanly on v3.5-rc3.

Care to respin?

Yours,
Linus Walleij
