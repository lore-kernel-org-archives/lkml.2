Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753637Ab1L0Kkz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 05:40:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55502 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab1L0Kkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 05:40:52 -0500
Date: Tue, 27 Dec 2011 10:40:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org
Subject: Re: [PATCHv2] Regulator: Add Anatop regulator driver
Message-ID: <20111227104048.GD2870@opensource.wolfsonmicro.com>
References: <1323265998-29088-2-git-send-email-paul.liu@linaro.org>
 <1324458211-1612-1-git-send-email-paul.liu@linaro.org>
 <20111222113337.GL4546@opensource.wolfsonmicro.com>
 <4EF998A3.4070403@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EF998A3.4070403@linaro.org>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 06:06:27PM +0800, Ying-Chun Liu (PaulLiu) wrote:
> (2011年12月22日 19:33), Mark Brown wrote:

> >> +#include <linux/platform_device.h>
> >> +#include <linux/regulator/machine.h>

> > Why does your regulator driver need this?  That suggests a layering
> > violation.

> Sorry, I'm not sure what does this mean.
> But if I want to access regulator_constraints, shouldn't I include this
> header file?

If your regulator driver wants to access regulator_constraints it is
doing something wrong, that should never be required.
