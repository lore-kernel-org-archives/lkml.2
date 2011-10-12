Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384Ab1JLN5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 09:57:19 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42514 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab1JLN5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 09:57:18 -0400
Message-ID: <4E959C7C.40901@linaro.org>
Date: Wed, 12 Oct 2011 21:56:12 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20111005 Icedove/3.1.15
MIME-Version: 1.0
To: ashish.jangam@kpitcummins.com
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linaro-dev@lists.linaro.org, lrg@slimlogic.co.uk,
        linux-kernel@vger.kernel.org, Dajun <dajun.chen@diasemi.com>
Subject: Re: [Patch 5/11] Regulator: DA9052/53 regulator support v4
References: <1317990038.5372.6.camel@L-0761.kpit.com>
In-Reply-To: <1317990038.5372.6.camel@L-0761.kpit.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011年10月07日 20:20), ashishj3 wrote:
> The Dialog PMIC has below featured regulators:-
> DA9052-BC - 4 DVS Buck converters 0.5V - 3.6V upto 1Amp.
> DA9053-AA/BX - 4 DVS Buck converters 0.5V - 2.5V upto 3Amp.
> DA9052/53 - 10 Programmable LDO's High PSSR, 1% accuracy.
> 
> This patch support all the DA9052 and Da9053 regulators. The output voltages are
> fully programmable via I2C or SPI interface. The platform data with regulation
> constraints is passed down from the board to the regulator.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> CC: Mark Brown <broonie@opensource.wolfsonmicro.com>

Tested-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>

Hi,

I've reviewed the source code and tested this driver on imx53 QuickStart
board. Works good.

There are some minor warnings and error by running checkpatch.pl on this
patch.

WARNING: please write a paragraph that describes the config symbol fully
#50: FILE: drivers/regulator/Kconfig:173:
+	help

ERROR: do not set execute permissions for source files
#70: FILE: drivers/regulator/da9052-regulator.c

WARNING: line over 80 characters
#117: FILE: drivers/regulator/da9052-regulator.c:43:
+	{800000, 1000000, 1200000, 1500000}, /* DA9053-AA/Bx BUCK-PRO,MEM,PERI */

Yours Sincerely,
Paul
