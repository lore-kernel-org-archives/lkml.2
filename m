Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab2FTTY3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:24:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60553 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104Ab2FTTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:24:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Subject: Re: [PATCH V3 2/3] regulator: dt: regulator match by regulator-compatible
Date: Wed, 20 Jun 2012 19:24:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: broonie@opensource.wolfsonmicro.com, lrg@ti.com, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, linus.walleij@linaro.org,
        lee.jones@linaro.org, swarren@wwwdotorg.org,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1340194987-23654-1-git-send-email-ldewangan@nvidia.com> <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1340194987-23654-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206201924.09618.arnd@arndb.de>
X-Provags-ID: V02:K0:UmMDMGrQaffqpra6awUSoD0MAN39Ox8Ulwes1sVu2v8
 7SUWAtSjHHV916mE/ijhfOs/PqLPRWUq30Y8uTXt0aLP2dQfL7
 Piq5EYZy4f0g+qiTtjIqroM2WWDB0u+EMAN0MeBWMiLblSbltM
 BpDWDfRAs59WJ97ixVv+qbgkxnycPeF5aHmjHC/ZAG12DeMraP
 MnG5xflVJz1n4WWF0SGijeOuT+MXLfB4lkQSjnhYdH3hfwGFCQ
 Mwm7H6dgTC8Bx1hqv7CfiEk1yT25f/d+KcY5/vkF1xMDx/8lic
 MzxFGLKUzQNoOiFY0+4IhwhEkzEbe1C+h5lucNlM6/5BfuAOS0
 NZ5e+lAuIcFkUUd/NAFI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2012, Laxman Dewangan wrote:
> Match the device's regulators with the property of
> "regulator-compatible" of each regulator node.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Acked-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> Changes from V1:
> - In place of adding new api, modify the existing api of_regulator_match() to
> look regulator-compatible for matching.
> 
> Changes from V2:
> - Add break if the regualtor match found.


I've read the entire series a few times and I still can't figure out
why you're doing it. *Please* describe what the change is good for,
now what you are doing in it.

All I can tell from the patch and/or description right now is that
you are adding a third identifier next the phandle and the
"regulalator-name", but not why this is a good idea.

Specifically, please explain these two things in the changelog:

1. What is it that the new property can express that cannot already
be expressed by using the phandle.

2. Why is it called "regulator-compatible"? If it's similar to the
"compatible" property, don't you have to have a binding for each
possible string? If it's not related to the "compatible" property,
why is it named in a similar way?

	Arnd
