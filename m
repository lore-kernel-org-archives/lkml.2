Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab1GFJLV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 05:11:21 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:35619 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753920Ab1GFJLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 05:11:20 -0400
Message-ID: <4E1426A4.7040709@linaro.org>
Date: Wed, 06 Jul 2011 14:41:00 +0530
From: Tushar Behera <tushar.behera@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: ashish.jangam@kpitcummins.com
CC: Dajun <dajun.chen@diasemi.com>, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, lrg@slimlogic.co.uk
Subject: Re: [Patch 5/11] Regulator: DA9052 regulator support v2
References: <1309353138.4448.6.camel@L-0532.kpit.com>
In-Reply-To: <1309353138.4448.6.camel@L-0532.kpit.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 29 June 2011 06:42 PM, ashishj3 wrote:
> The DA9052 PMIC has below featured regulators:-
> 4 DVS Buck converters 0.5V - 3.6V upto 1Amp.
> 10 Programmable LDO's High PSSR, 1% accuracy.
>
> This patch support all the DA9052 regulators. The output voltages are fully
> programmable via I2C or SPI interface. The platform data with regulation
> constraints is passed down from the board to the regulator.
>
> Signed-off-by: David Dajun Chen<dchen@diasemi.com>
> Signed-off-by: Ashish Jangam<ashish.jangam@kpitcummins.com>
> CC: Mark Brown<broonie@opensource.wolfsonmicro.com>
Having patch version info as [Patch V2 5/11] would be better.
	
	git format-patch --subject-prefix="Patch V2" ...

[...]

-- 
Tushar Behera
