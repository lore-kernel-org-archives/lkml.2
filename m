Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab2ITGzj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 02:55:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33339 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2ITGzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 02:55:38 -0400
MIME-Version: 1.0
In-Reply-To: <1348045056-29769-2-git-send-email-thierry.reding@avionic-design.de>
References: <1348045056-29769-1-git-send-email-thierry.reding@avionic-design.de>
	<1348045056-29769-2-git-send-email-thierry.reding@avionic-design.de>
Date: Thu, 20 Sep 2012 08:55:37 +0200
Message-ID: <CACRpkda7dZmQNT2T3CnJjC9Au23ny2CrMao-tpxujw5Uqa-O-Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: adnp: dt: Reference generic interrupt binding
From: Linus Walleij <linus.walleij@linaro.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Rob Herring <rob.herring@calxeda.com>, devicetree-discuss@lists.ozlabs.org,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 10:57 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:

> Instead of having to duplicate the description of the properties needed
> for interrupt support, reference the new standard document.
>
> Cc: Linus Walleij <linus.walleij@stericsson.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: devicetree-discuss@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> ---
> This patch should go through LinusW's tree because it already carries
> the patch that created this documentation.

Applied with Rob's ACK and the minor spelling correction.

Thanks!
Linus Walleij
