Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334Ab2ABRjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 12:39:08 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46524 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752654Ab2ABRjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 12:39:06 -0500
MIME-Version: 1.0
In-Reply-To: <CAH9JG2WjhSsqxPFj+DQrOKXzbHPhm1ddNYE2AeukS7u9c_LA-g@mail.gmail.com>
References: <1325483675-21908-1-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-2-git-send-email-thomas.abraham@linaro.org>
	<1325483675-21908-3-git-send-email-thomas.abraham@linaro.org>
	<CAH9JG2WjhSsqxPFj+DQrOKXzbHPhm1ddNYE2AeukS7u9c_LA-g@mail.gmail.com>
Date: Mon, 2 Jan 2012 23:09:05 +0530
Message-ID: <CAJuYYwTtXO6+weJ6YANJGUTy90JF3oiCFbDGjgp0GTb7UNUpxw@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/4] lcd: platform-lcd: Add support for Hydis
 hv070wsa lcd panel
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Kyungmin Park <kyungmin.park@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        rpurdie@rpsys.net, linux-samsung-soc@vger.kernel.org,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        kgene.kim@samsung.com, jg1.han@samsung.com,
        broonie@opensource.wolfsonmicro.com, cbou@mail.ru,
        kwangwoo.lee@gmail.com, augulis.darius@gmail.com, ben-linux@fluff.org,
        patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Park,

On 2 January 2012 13:32, Kyungmin Park <kyungmin.park@samsung.com> wrote:
> Hi,
>
> It's not clear to add the panel data at platform_lcd. It's board
> specific and it's used the gpio only.
> So no need to specific it like HYDIS_HV070WSA. just define
> PLATFORM_LCD_GPIO or similar.
>
> How do you think?

Yes, I agree. Looking at other users of platform-lcd driver, it is
better to use config option as you mentioned since many lcd panels use
a single gpio for enable/disable of the panel. I will prepare a new
patch with these changes.

Thanks,
Thomas.

[...]
