Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab2JKOWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 10:22:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:53581 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab2JKOWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 10:22:21 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 11 Oct 2012 07:23:09 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jean Delvare <khali@linux-fr.org>, David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: da9052: Use da9052_reg_update for rmw operations
Message-ID: <20121011142309.GA17164@roeck-us.net>
References: <1349964231.9925.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349964231.9925.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 10:03:51PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/hwmon/da9052-hwmon.c |   27 +++++++--------------------
>  1 file changed, 7 insertions(+), 20 deletions(-)
> 
Applied to -next.

Thanks,
Guenter
