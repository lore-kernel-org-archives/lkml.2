Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933043Ab2GEN1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:27:49 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:34538 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932483Ab2GEN1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:27:48 -0400
MIME-Version: 1.0
In-Reply-To: <1340945879-11712-3-git-send-email-acourbot@nvidia.com>
References: <1340945879-11712-1-git-send-email-acourbot@nvidia.com>
	<1340945879-11712-3-git-send-email-acourbot@nvidia.com>
Date: Thu, 5 Jul 2012 15:27:47 +0200
Message-ID: <CACRpkdaazZTufukCmCWmqOsuwnYSoQoAcnC3iUoqqiAkt3X7eA@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: propagate of_parse_phandle_with_args errors
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 6:57 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:

> Make of_get_named_gpio_flags propagate any error it receives from
> of_parse_phandle_with_args instead of inconditionally returning -EINVAL.
>
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Applied.

Thanks,
Linus Walleij
