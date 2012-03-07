Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab2CGEdk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:33:40 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:10957 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759030Ab2CGEdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:33:39 -0500
X-AuditID: cbfee61b-b7c62ae000000989-69-4f56e5219ac6
From: Sangbeom Kim <sbkim73@samsung.com>
To: axel.lin@gmail.com, linux-kernel@vger.kernel.org
Cc: "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
References: <1331093522.3143.3.camel@phoenix>
 <CAF+7xWkxLZkFV=oh-daLeBchd=vFjw5jeBLNqmMiSu4LYQEYOA@mail.gmail.com>
In-reply-to: <CAF+7xWkxLZkFV=oh-daLeBchd=vFjw5jeBLNqmMiSu4LYQEYOA@mail.gmail.com>
Subject: RE: [PATCH] regulator: Rename s5m8767_convert_voltage to
 s5m8767_get_proper_voltage_sel
Date: Wed, 07 Mar 2012 13:33:37 +0900
Message-id: <047801ccfc1b$76f07b50$64d171f0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz8GSRIXyyKw1KCTYyKb/QWataWxQAAF/GA
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> > I was confused by the function name, s5m8767_convert_voltage() converts
> what to what?
Convert means that Normal Voltage unit to 8767 internal voltage register
unit.
> BTW, I'm also confused by s5m8767_set_high and s5m8767_set_low functions.
> Both function sets the same gpios to the same state. ( by different order
)
> Maybe we need comments (or rename) for both functions.
S5M8767A can be controlled with 3 GPIO.
To control voltage with GPIO, Order is very important.
Because Voltage inversion should not be happened.
If DVFS table is like a below,
1.5Ghz  1.5V
1.0Ghz  1.0V
0.5Ghz  0.5V

If System try to change 1.0Ghz(1.0V) -> 1.5Ghz(1.5V)
Absolutely 0.5V should not be set.

Thanks,
Sangbeom.

