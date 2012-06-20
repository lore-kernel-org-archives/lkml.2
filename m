Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755672Ab2FTI7f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:59:35 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44578 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2FTI7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:59:33 -0400
MIME-Version: 1.0
In-Reply-To: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
Date: Wed, 20 Jun 2012 10:59:32 +0200
Message-ID: <CACRpkdYSLiLZwVwY1tU9PWGTx2EGP6OykeXE5rtwRKAHror-Yg@mail.gmail.com>
Subject: Re: [PATCH V2 0/3] regulator: dt: add policy to match regulator with
 prop "regulator-compatible"
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>,
        devicetree-discuss@lists.ozlabs.org
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, arnd@arndb.de, lrg@ti.com,
        lee.jones@linaro.org, swarren@wwwdotorg.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 4:28 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> add policy to match regulator with the property of "regulator-compatible" of each
> child regulator node with their hardware counterparts name.
> Modify documentation as well to reflect this change and dts files.
>
> Changes from V1:
> - Modify the existing of_regulator_match() to use the property
>  "regulator-compatible" of each child node of regulator for
>   matching rather than child node name.
> - Documentation change to reflect this policy who are using the
>  of_regulator_match().
> - Modify the dts file to absorb this policy.

If I had today deployed the device trees generated prior to this patch,
and try to boot kernels after this patch with the same device tree,
would they still work as expected?

I don't know it it's an issue right now, but at some point we need to
realize that people will expect old device trees to work on newer
kernels.

Yours,
Linus Walleij
