Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306Ab2ABRdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 12:33:44 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55509 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037Ab2ABRdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 12:33:42 -0500
MIME-Version: 1.0
In-Reply-To: <20120102073406.GG13015@ponder.secretlab.ca>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-3-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-4-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-5-git-send-email-thomas.abraham@linaro.org>
	<20120102073406.GG13015@ponder.secretlab.ca>
Date: Mon, 2 Jan 2012 23:03:41 +0530
Message-ID: <CAJuYYwTk=+p=FQeM4eyhLt-qKzTdb2KuJ=OZmSPng1qK-jyzJg@mail.gmail.com>
Subject: Re: [RFC][PATCH 4/4] lcd: platform-lcd: Add device tree support
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        rob.herring@calxeda.com, kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, kyungmin.park@samsung.com,
        cbou@mail.ru, kwangwoo.lee@gmail.com, augulis.darius@gmail.com,
        ben-linux@fluff.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On 2 January 2012 13:04, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Mon, Jan 02, 2012 at 11:24:35AM +0530, Thomas Abraham wrote:
>> Add device tree based initialization for Hydis hv070wsa lcd panel.
>>
>> Cc: Ben Dooks <ben-linux@fluff.org>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
>>  drivers/video/backlight/platform_lcd.c |   33 ++++++++++++++++++++++++++++++++
>>  1 files changed, 33 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/video/backlight/platform_lcd.c b/drivers/video/backlight/platform_lcd.c

[...]

>> +#ifdef CONFIG_OF
>> +     if (pdev->dev.of_node) {
>> +             const struct of_device_id *match;
>> +             match = of_match_node(platform_lcd_dt_match, pdev->dev.of_node);
>> +             return (struct plat_lcd_driver_data *)match->data;
>
> .data is already void*; the cast should not be necessary.

Thanks. I will remove the cast.

Regards,
Thomas.

[...]
