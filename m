Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759266Ab2C2MmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 08:42:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40154 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758338Ab2C2MmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 08:42:15 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <1332130930.26765.2.camel@phoenix>
References: <1332130930.26765.2.camel@phoenix>
From: Axel Lin <axel.lin@gmail.com>
Date: Thu, 29 Mar 2012 20:41:54 +0800
Message-ID: <CAF+7xWm64cN23_X9bt37k809eF2OdmxAFf6dVXutoQxfU6Mydw@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/4] regulator: Fix setting new voltage in s5m8767_set_voltage
To: linux-kernel@vger.kernel.org
Cc: Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/3/19 Axel Lin <axel.lin@gmail.com>:
> Current code does not really update the register with new value, fix it.
> I rename the variable i to sel for better readability.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
> Hi Sangbeom,
> I make the following patchs on top of this one, so I resend this one as the
> first patch of this serial.
> I'd appreciate to have your feedback about the changes in this patch serial.
>
Hi Sangbeom,
Are you OK with this patch serial?
I think current code in s5m8767_set_voltage() does not work without this patch.

Regards,
Axel
