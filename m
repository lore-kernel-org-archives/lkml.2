Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab2CICkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 21:40:37 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34395 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751225Ab2CICkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 21:40:36 -0500
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <069e01ccfd9c$62b5f840$2821e8c0$@com>
References: <1331093522.3143.3.camel@phoenix> <069e01ccfd9c$62b5f840$2821e8c0$@com>
From: Axel Lin <axel.lin@gmail.com>
Date: Fri, 9 Mar 2012 10:40:15 +0800
Message-ID: <CAF+7xWm24=aq4G0uAS3ihhS8rzvhKNTJZMjJDRgMrY+fnGu0uA@mail.gmail.com>
Subject: Re: [PATCH] regulator: Rename s5m8767_convert_voltage to s5m8767_get_proper_voltage_sel
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sangbeom,

2012/3/9 Sangbeom Kim <sbkim73@samsung.com>:
> Hi!
>
> On Wednesday, Mar 07, 2012 at 1:12AM, Axel Lin wrote:
>> -static inline int s5m8767_convert_voltage(
>> +static int s5m8767_get_proper_voltage_sel(
>
> s5m8767_get_voltage_sel and s5m8767_get_proper_voltage_sel
> have confusion too.

How about s5m8767_convert_voltage_to_proper_sel ?

If it is ok for you, I'll send the patch right away. :-)

Regards,
Axel
