Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2FSRoD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 13:44:03 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36196 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2FSRoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 13:44:00 -0400
Message-ID: <4FE0BA5C.9020405@wwwdotorg.org>
Date: Tue, 19 Jun 2012 11:43:56 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, arnd@arndb.de, linus.walleij@linaro.org,
        lrg@ti.com, lee.jones@linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/3] regulator: dt: add policy to have property "regulator-compatible"
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com> <1340116099-17629-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340116099-17629-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2012 08:28 AM, Laxman Dewangan wrote:
> Add the policy for regulator DT such that each regulator child node
> must have the property "regulator-compatible" which matches with
> regulator name of their hardware counterparts.
> Modify the dt documentation of regulator devices to reflect this
> policy.

> diff --git a/Documentation/devicetree/bindings/mfd/tps65910.txt b/Documentation/devicetree/bindings/mfd/tps65910.txt

>    device need to be present. The definition for each of these nodes is defined
>    using the standard binding for regulators found at
>    Documentation/devicetree/bindings/regulator/regulator.txt.
> +  The regulator is matched with the regulator-compatible.

That last sentence should be true for any chip containing multiple
regulators and using the standard regulator binding. As such, shouldn't
that property be part of regulator.txt, rather than each individual
regulator chip's binding document?

> -  The valid names for regulators are:
> +  The valid regulator-compatible for regulators are:

Perhaps "The valid regulator-compatible values are:"
