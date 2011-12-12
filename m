Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752505Ab1LLHoI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 02:44:08 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57857 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1LLHoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 02:44:05 -0500
Date: Sun, 11 Dec 2011 23:43:58 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-input@vger.kernel.org
Subject: Re: [PATCH] Input: mc13783-pwrbutton - convert to use
 module_platform_driver()
Message-ID: <20111212074358.GB4682@core.coreip.homeip.net>
References: <1323396846.3740.10.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323396846.3740.10.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 10:14:06AM +0800, Axel Lin wrote:
> This patch converts mc13783-pwrbutton to use the module_platform_driver()
> macro which makes the code smaller and a bit simpler.
> 
> Also staticise mc13783_pwrbutton_driver which is not used outside
> this driver so no need to make the symbol global.
> 

Applied, thank you Axel.

-- 
Dmitry
