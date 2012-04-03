Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751841Ab2DCFkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 01:40:51 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:8239 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860Ab2DCFku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 01:40:50 -0400
X-AuditID: cbfee61b-b7baeae000004fa7-b3-4f7a8d60251b
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Axel Lin'" <axel.lin@gmail.com>, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1332130930.26765.2.camel@phoenix>
 <1332131021.26765.4.camel@phoenix>
In-reply-to: <1332131021.26765.4.camel@phoenix>
Subject: RE: [PATCH RFC 2/4] regulator: Rework s5m8767_set_voltage to support
 both LDOs and BUCKs
Date: Tue, 03 Apr 2012 14:40:48 +0900
Message-id: <01af01cd115c$52c63fc0$f852bf40$@com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac0FiClJZ8rnN6ZAT5etHysh5LcIZgLz7YhQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 1:24 PM, Axel Lin wrote:
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

Acked-by: Sangbeom Kim <sbkim73@samsung.com>

Thanks,
Sangbeom.

