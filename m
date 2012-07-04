Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab2GDHIG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:08:06 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:5648 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2GDHIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:08:02 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 04 Jul 2012 00:04:28 -0700
Message-ID: <4FF3EAC5.8060209@nvidia.com>
Date: Wed, 4 Jul 2012 12:33:33 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "lrg@ti.com" <lrg@ti.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3 3/3] regulator: dt: add policy to have property "regulator-compatible"
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <1340194987-23654-4-git-send-email-ldewangan@nvidia.com> <20120703192508.GG29030@opensource.wolfsonmicro.com>
In-Reply-To: <20120703192508.GG29030@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 July 2012 12:55 AM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Wed, Jun 20, 2012 at 05:53:07PM +0530, Laxman Dewangan wrote:
>> Add the policy for regulator DT such that if device have multiple
>> regulator and its binding contains a child node that describes each
>> regulator then each regulator child node must have the property
>> "regulator-compatible" which matches with regulator name of their
>> hardware counterparts.
> I tried to apply this but both git and patch are upset with the patch at
> the line:
>
> diff --git a/Documentation/devicetree/bindings/regulator/tps6586x.txt b/Documentation/devicetree/bindings/regulator/tps6586x.txt
>
> for reasons I'm not immediately able to discern.  Can you please look
> into this?

I will locally try and will resend the patch if anything change.

