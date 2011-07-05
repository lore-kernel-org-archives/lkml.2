Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab1GEMeF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 08:34:05 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58715 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754267Ab1GEMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 08:34:04 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Subject: Re: [PATCH 1/11] MFD: DA9052 MFD core module v1
Date: Tue, 5 Jul 2011 14:33:59 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "sameo@openedhand.com" <sameo@openedhand.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dajun <dajun.chen@diasemi.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>
References: <1309270609.376.226.camel@L-0532.kpit.com> <201106291427.11534.arnd@arndb.de> <E2CAE7F7B064EA49B5CE7EE9A4BB167D18F6DB1B06@KCINPUNHJCMS01.kpit.com>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D18F6DB1B06@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051433.59235.arnd@arndb.de>
X-Provags-ID: V02:K0:NPkQ2436sOSDipW/xHj+P1uR/Ki1C6WiZtjdpxEBjwh
 1b61KS4oBW2CVYqA9+inVLw3PDIz4Y+tzrjEythE9TIJd831DR
 yphzYSsiXd41viB79+zuXrFAX7b8Cz2tmARLZwGekS+pvmR7NF
 yrSwJfgEiiZgxoVSZ9IC4cTk61UNMLGWZJH3ZAa3AcosrCMppF
 9OEXosu4FTJiT5LdaQxKA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 05 July 2011, Ashish Jangam wrote:
> DA9053 chip submission was done by Linaro and now they have agreed that
> we will be only responsible for DA9053 submission too so now we can
> skip the posted DA9053 patch.

Ok.

> Regarding file naming convention da9052 seems to be appropriate since 
> DA9053 chip is update of DA9052 and also DA9052 is the umbrella name
> for the whole family.

What about the existing da903x drivers for leds, touchscreen, battery,
regulator and backlight? Are they all completely distinct from the
da905x line?

	Arnd
