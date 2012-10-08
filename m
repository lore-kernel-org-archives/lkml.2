Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751256Ab2JHPfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 11:35:47 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50229 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab2JHPfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 11:35:44 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 8 Oct 2012 08:36:28 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: khali@linux-fr.org, yongjun_wei@trendmicro.com.cn,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: ina2xx: use module_i2c_driver to simplify the code
Message-ID: <20121008153628.GA11734@roeck-us.net>
References: <CAPgLHd99+yWL1br_FgWbj=5vnjRWoAAqe9ME6LS45aCj=Ga-Wg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd99+yWL1br_FgWbj=5vnjRWoAAqe9ME6LS45aCj=Ga-Wg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 08:40:35PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Use the module_i2c_driver() macro to make the code smaller
> and a bit simpler.
> 
> dpatch engine is used to auto generate this patch.
> (https://github.com/weiyj/dpatch)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Applied to -next.

Thanks,
Guenter
