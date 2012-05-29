Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2E2JFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 05:05:42 -0400
Received: from mga14.intel.com ([143.182.124.37]:2607 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501Ab2E2JFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 05:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="105323977"
Date: Tue, 29 May 2012 11:15:56 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: axel.lin@gmail.com, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] mfd: Remove config AB8500_I2C_CORE Kconfig entry
Message-ID: <20120529091556.GB18977@sortiz-mobl>
References: <1338272340.3127.1.camel@phoenix>
 <4FC47CEB.8090106@linaro.org>
 <CAF+7xWnriCRAuGzTusrtCkYTyUNPKVXE_f0kwysNJ3=AkuzvvA@mail.gmail.com>
 <4FC488E1.3080406@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC488E1.3080406@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

On Tue, May 29, 2012 at 04:29:21PM +0800, Lee Jones wrote:
> On 29/05/12 15:53, Axel Lin wrote:
> >2012/5/29 Lee Jones<lee.jones@linaro.org>:
> >>On 29/05/12 14:19, Axel Lin wrote:
> >>>
> >>>config AB8500_I2C_CORE is not used after commit d28f1db
> >>>"mfd: Remove confusing ab8500-i2c file and merge into ab8500-core".
> >>>Thus remove it.
> >>>
> >>>Signed-off-by: Axel Lin<axel.lin@gmail.com>
> >>
> >>
> >>I have this patch embedded into a patch-set I'm going to send to ARM-SoC for
> >>inclusion into -rc1 this afternoon. Would you mind leaving this one?
> >
> >I don't mind.
> >But AFAIK, commit d28f1db is in mfd tree.
> >Any reason you want to send the patch to ARM-SoC instead of mfd tree.
> 
> I don't actually have a preference as to which tree it goes into, so
> long as it's sent to Mainline on or before -rc1. 
I sent a pull request to Linus yesterday, including this commit.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
