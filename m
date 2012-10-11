Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758761Ab2JKQWA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 12:22:00 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58251 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756217Ab2JKQV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 12:21:59 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 11 Oct 2012 09:22:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Axel Lin <axel.lin@ingics.com>
Cc: Jean Delvare <khali@linux-fr.org>, Lothar Felten <l-felten@ti.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (ina2xx) Use module_i2c_driver macro
Message-ID: <20121011162251.GA31269@roeck-us.net>
References: <1349970986.9548.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349970986.9548.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 11:56:26PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
>  drivers/hwmon/ina2xx.c |   13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)
> 
Hi Axel,

A similar patch from Wei Yongjun is already queued in my -next branch.
It is not in linux-next yet since I am supposed to hold off until
the commit window closes. 

Thanks,
Guenter
