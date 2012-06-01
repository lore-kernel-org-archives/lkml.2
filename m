Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649Ab2FABkR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 21:40:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60890 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab2FABkP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 21:40:15 -0400
MIME-Version: 1.0
In-Reply-To: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
References: <1337816857-14694-1-git-send-email-thomas.abraham@linaro.org>
Date: Fri, 1 Jun 2012 09:40:14 +0800
Message-ID: <CACRpkdZ++GiqE55ofuwOssY4RLE5NctiY1rik1PDtm5r+CL4dw@mail.gmail.com>
Subject: Re: [PATCH 0/3] pinctrl: add support for samsung pinctrl driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        kgene.kim@samsung.com, kyungmin.park@samsung.com, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 7:47 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

> Note that, the Samsung pinctrl driver is usable only on device tree enabled
> Samsung platforms. Legacy platforms would still continue to use the older
> gpiolib driver and hence updates to device drivers to use the pinctrl api
> should ensure that support for legacy platforms is maintained.

Is the plan to move also the older platforms over to the DT-based model?
It'd be really nice to be able to just delete the old drivers at some point...

Yours,
Linus Walleij
