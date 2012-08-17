Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758215Ab2HQPCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 11:02:40 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:42742 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758130Ab2HQPCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 11:02:33 -0400
MIME-Version: 1.0
In-Reply-To: <20120808131158.GD8227@gmail.com>
References: <1344266253-14050-1-git-send-email-lee.jones@linaro.org>
	<20120808131158.GD8227@gmail.com>
Date: Fri, 17 Aug 2012 17:02:32 +0200
Message-ID: <CACRpkdb+6S5yYvVjrr2f+wubE43dzD3i=OVfWtM_U+HW_XZX1A@mail.gmail.com>
Subject: Re: [PATCH 1/1 v4] i2c: Add default configuration into the Nomadik
 I2C driver.
From: Linus Walleij <linus.walleij@linaro.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-i2c@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 3:11 PM, Lee Jones <lee.jones@linaro.org> wrote:

> From: Lee Jones <lee.jones@linaro.org>
> Date: Tue, 7 Aug 2012 12:27:24 +0100
> Subject: [PATCH 1/1 v4] i2c/nomadik: Add default configuration into the Nomadik I2C driver

Wolfram are you taking this v4 patch into the i2c tree for the -rc:s?

Right now this is causing boot regressions so we need it badly...

Yours,
Linus Walleij
