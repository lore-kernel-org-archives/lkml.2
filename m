Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab2DBXQO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 19:16:14 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:28628 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498Ab2DBXQM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 19:16:12 -0400
X-AuditID: cbfee61b-b7baeae000004fa7-de-4f7a333aba7d
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1332130930.26765.2.camel@phoenix>
 <1332131021.26765.4.camel@phoenix>
In-reply-to: <1332131021.26765.4.camel@phoenix>
Subject: RE: [PATCH RFC 2/4] regulator: Rework s5m8767_set_voltage to support
 both LDOs and BUCKs
Date: Tue, 03 Apr 2012 08:16:10 +0900
Message-id: <019601cd1126$971508e0$c53f1aa0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0FiClJZ8rnN6ZAT5etHysh5LcIZgLnXMDA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2012 at 1:24 PM, Axel Lin wrote:
 
> s5m8767_set_voltage not only implement set_voltage callbacks for LDOs,
> but also for BUCKs when s5m8767->buck_gpioindex is not set.
> s5m8767_set_voltage_buck actually only for buck[2|3|4] when
> s5m8767->buck_gpioindex is set.
> Conditionally calling s5m8767_set_voltage in s5m8767_set_voltage_buck makes
> the code hard to read.
> 
> I think merging s5m8767_set_voltage_buck and s5m8767_set_voltage actually
> simplifies things. It's easy to use buck234_vol pointer to differentiate if
> we need to control voltage for buck[2|3|4] by DVS GPIOs.
> 
> This patch reworks s5m8767_set_voltage to support both LDOx and BUCKx in all
> cases.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Hi, Axel
Basically, Your optimization code looks good.
But, S5M8767A support 9 Bucks. 
Please Add #9 Buck handling too.
As you know, 3.4-rc1 is released.
Please rebase your patch on 3.4-rc1.
Some feature is added on 3.4-rc1.

Thanks,
Sangbeom.


