Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2IZX4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 19:56:30 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62088 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab2IZX42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 19:56:28 -0400
Date: Wed, 26 Sep 2012 16:56:41 -0700
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        arm@kernel.org, Anmar Oueja <anmar.oueja@linaro.org>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] ARM: ux500: 8500: update I2C sleep states pinctrl
Message-ID: <20120926235641.GB6567@quad.lixom.net>
References: <1348570915-3116-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348570915-3116-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 01:01:55PM +0200, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@stericsson.com>
> 
> This defines the proper sleep states for all the I2C pins of
> the MOP500 DB8500 ASIC setting.
> 
> Signed-off-by: Patrice Chotard <patrice.chotard@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Requesting ARM SoC ACKs to take this through pinctrl for
> ease-of-merge going forward, as dependecies are in there.

Acked-by: Olof Johansson <olof@lixom.net>


-Olof
