Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab2AQQyy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 11:54:54 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39771 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab2AQQyw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 11:54:52 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6591"; a="153373085"
Message-ID: <4F15A7D0.1010901@codeaurora.org>
Date: Tue, 17 Jan 2012 08:54:40 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH] regulator: Add devm_regulator_get()
References: <1326771598-28124-1-git-send-email-sboyd@codeaurora.org> <20120117110454.GD2944@opensource.wolfsonmicro.com>
In-Reply-To: <20120117110454.GD2944@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/12 03:04, Mark Brown wrote:
> On Mon, Jan 16, 2012 at 07:39:58PM -0800, Stephen Boyd wrote:
>
>> @@ -200,6 +202,11 @@ static inline struct regulator *__must_check regulator_get(struct device *dev,
>>  	 */
>>  	return NULL;
>>  }
>> +static inline struct regulator *__must_check
>> +devm_regulator_get(struct device *dev, const char *id)
>> +{
>> +	return NULL;
>> +}
>>  static inline void regulator_put(struct regulator *regulator)
>>  {
>>  }
> Oh, and it's not obvious from the diff but blank lines please like the
> adjacent code.

Should I resend or are you ok with adding the newline there yourself?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

