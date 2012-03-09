Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab2CIIAc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 03:00:32 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:36769 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752264Ab2CIIAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 03:00:30 -0500
Message-ID: <4F59B899.2080704@linaro.org>
Date: Fri, 09 Mar 2012 16:00:25 +0800
From: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111114 Icedove/3.1.16
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Nancy Chen <Nancy.Chen@freescale.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH v10] Regulator: Add Anatop regulator driver
References: <1331200744-5986-1-git-send-email-paul.liu@linaro.org> <20120308141847.GG27213@game.jcrosoft.org>
In-Reply-To: <20120308141847.GG27213@game.jcrosoft.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012年03月08日 22:18), Jean-Christophe PLAGNIOL-VILLARD wrote:
>> +static int __devexit anatop_regulator_remove(struct platform_device *pdev)
>> +{
>> +	struct regulator_dev *rdev = platform_get_drvdata(pdev);
>> +	struct anatop_regulator *sreg = rdev_get_drvdata(rdev);
>> +	kfree(sreg->name);
>> +	regulator_unregister(rdev);
> return from the unregister
>> +	return 0;
>> +}
> Best Regards,
> J.

Hi Jean-Christophe,

I've modify the patch based on your review. However, the last one cannot
be made because regulator_unregister is void return.

Yours Sincerely,
Paul
