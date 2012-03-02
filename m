Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab2CBHwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:52:00 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62535 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2CBHv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:51:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.liu@linaro.org designates 10.68.132.69 as permitted sender) smtp.mail=paul.liu@linaro.org
Message-ID: <4F507C1B.1050909@linaro.org>
Date: Fri, 02 Mar 2012 15:51:55 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Shawn Guo <shawn.guo@linaro.org>
Subject: Re: [PATCH v6 1/2] mfd: Add anatop mfd driver
References: <1330593052-15184-1-git-send-email-paul.liu@linaro.org> <1330671641-6439-1-git-send-email-paul.liu@linaro.org> <D958900912E20642BCBC71664EFECE3E6DD2912252@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6DD2912252@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年03月02日 15:07), Venu Byravarasu wrote:
> Why you did not made use of regmap?
> 

Hi Venu,

I cannot fully understand. Anatop is not SPI or I2C device. It is
internally embedded into the SoC. It is directly accessed by memory I/O.

Do you mean I should implement a regmap_bus which uses memory I/O and
then use regmap?

Regards,
Paul

>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> owner@vger.kernel.org] On Behalf Of Ying-Chun Liu (PaulLiu)
>> Sent: Friday, March 02, 2012 12:31 PM
>> To: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org; linaro-dev@lists.linaro.org;
>> patches@linaro.org; Ying-Chun Liu (PaulLiu); Samuel Ortiz; Mark Brown; Shawn
>> Guo
>> Subject: [PATCH v6 1/2] mfd: Add anatop mfd driver
>>
>> From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
>>
>> Anatop is a mfd chip embedded in Freescale i.MX6Q SoC.
>> Anatop provides regulators and thermal.
>> This driver handles the address space and the operation of the mfd device.
>>
>> Signed-off-by: Ying-Chun Liu (PaulLiu) <paul.liu@linaro.org>
>> Cc: Samuel Ortiz <sameo@linux.intel.com>
>> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
>> Cc: Shawn Guo <shawn.guo@linaro.org>
>> ---
>>  drivers/mfd/Kconfig        |    6 ++

