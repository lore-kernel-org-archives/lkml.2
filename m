Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759428Ab2CGEQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 23:16:59 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:55102 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759263Ab2CGEQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 23:16:58 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1331093522.3143.3.camel@phoenix>
References: <1331093522.3143.3.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Wed, 7 Mar 2012 12:16:37 +0800
Message-ID: <CAF+7xWkxLZkFV=oh-daLeBchd=vFjw5jeBLNqmMiSu4LYQEYOA@mail.gmail.com>
Subject: Re: [PATCH] regulator: Rename s5m8767_convert_voltage to s5m8767_get_proper_voltage_sel
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/7 Axel Lin <axel.lin@gmail.com>:
> This function finds the smallest voltage that falls within the specified range,
> and then returns the selector. This rename makes the intention more clear.
>
> Also remove unneeded local variables min_vol and max_vol in s5m8767_set_voltage
> and s5m8767_set_voltage_buck.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> I was confused by the function name, s5m8767_convert_voltage() converts what to what?
>

BTW, I'm also confused by s5m8767_set_high and s5m8767_set_low functions.
Both function sets the same gpios to the same state. ( by different order )
Maybe we need comments (or rename) for both functions.

Regards,
Axel
