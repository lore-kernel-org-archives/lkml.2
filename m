Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab2JPFPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 01:15:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60077 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755815Ab2JPFPA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 01:15:00 -0400
Date: Tue, 16 Oct 2012 14:14:52 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        alsa-devel@alsa-project.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] ASoC: Ux500: Dispose of device nodes correctly
Message-ID: <20121016051444.GC8670@opensource.wolfsonmicro.com>
References: <1350306806-5688-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350306806-5688-1-git-send-email-lee.jones@linaro.org>
X-Cookie: Courage is your greatest present need.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 02:13:25PM +0100, Lee Jones wrote:
> When of_parse_phandle() is used to find a device node, its
> reference count is incremented by the helper. Once we're
> finished with them, it's our responsibly to ensure they
> are freed in the correct manor.

Applied both, thanks.
