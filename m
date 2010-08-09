Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055Ab0HIJ7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:59:41 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36133 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab0HIJ7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:59:40 -0400
Subject: Re: [PATCH RESEND again] regulator: lp3971 - remove unnecessary
 ret value checking in lp3971_i2c_write()
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
In-Reply-To: <1281344481.22819.3.camel@mola>
References: <1281344481.22819.3.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 10:59:25 +0100
Message-ID: <1281347965.3035.21.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 17:01 +0800, Axel Lin wrote:
> i2c_smbus_write_byte_data() returns zero or negative value,
> therefore no need to check if ret is greater than zero or not.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/regulator/lp3971.c |    8 +-------
>  1 files changed, 1 insertions(+), 7 deletions(-)
> 

Applied.

Thanks

Liam
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

