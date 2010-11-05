Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753676Ab0KEI4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 04:56:49 -0400
Received: from ch-smtp02.sth.basefarm.net ([80.76.149.213]:46070 "EHLO
	ch-smtp02.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753527Ab0KEI4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 04:56:47 -0400
Message-ID: <4CD3C6BB.4010601@euromail.se>
Date: Fri, 05 Nov 2010 09:56:27 +0100
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 6/8] hwmon: applesmc: Dynamic creation of
 fan files
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se> <1288511434-5662-7-git-send-email-rydberg@euromail.se> <20101105025933.GE28308@ericsson.com>
In-Reply-To: <20101105025933.GE28308@ericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1PEI60-0005RZ-9F.
X-Scan-Signature: ch-smtp02.sth.basefarm.net 1PEI60-0005RZ-9F 7f0374ca9dfabfe49eeaa48dd88c304c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>  static int applesmc_init_smcreg_try(void)

>>  {
>>         struct applesmc_registers *s = &smcreg;
>> +       u8 tmp[4];
> 
> Why tmp[4] if you only read one byte ?


Alignment optimization, perhaps? :-) I'll change it.

Thanks,
Henrik
