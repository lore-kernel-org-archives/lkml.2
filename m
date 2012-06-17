Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab2FQOVM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 10:21:12 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:62560 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757410Ab2FQOVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 10:21:10 -0400
MIME-Version: 1.0
In-Reply-To: <1339380868.13491.1.camel@phoenix>
References: <1339380868.13491.1.camel@phoenix>
Date: Sun, 17 Jun 2012 16:21:09 +0200
Message-ID: <CACRpkdZ1A=kKs9oWOhMmAsrvH0iNp9xuy9iUWzXh1fBnLOO8Ug@mail.gmail.com>
Subject: Re: [PATCH RFT] regulator: ab3100: Convert fixed voltage to use regulator_list_voltage_linear
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

On Mon, Jun 11, 2012 at 4:14 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

I tried to test this patch but it doesn't apply cleanly on v3.5-rc3, can you
respin it?

Yours,
Linus Walleij
