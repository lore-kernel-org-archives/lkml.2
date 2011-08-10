Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab1HJEYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 00:24:03 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33973 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750927Ab1HJEYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 00:24:01 -0400
Message-ID: <4E420761.1000108@metafoo.de>
Date: Wed, 10 Aug 2011 06:21:53 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110702 Icedove/3.0.11
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Convert pcf50633 to use new register map API
References: <1312790680-12195-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1312790680-12195-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2011 10:04 AM, Mark Brown wrote:
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Tested-by: Lars-Peter Clausen <lars@metafoo.de>

> ---
>  drivers/mfd/Kconfig               |    1 +
>  drivers/mfd/pcf50633-core.c       |  114 +++++++++++-------------------------
>  include/linux/mfd/pcf50633/core.h |    3 +-
>  3 files changed, 38 insertions(+), 80 deletions(-)
>  [...]
