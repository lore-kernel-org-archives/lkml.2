Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1LHOXB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 09:23:01 -0500
Received: from imr3.ericy.com ([198.24.6.13]:38879 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab1LHOW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 09:22:57 -0500
Date: Thu, 8 Dec 2011 06:21:09 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Axel Lin <axel.lin@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH] hwmon: jz4740: Staticise jz4740_hwmon_driver
Message-ID: <20111208142109.GB8163@ericsson.com>
References: <1323351217.3398.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1323351217.3398.0.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 08, 2011 at 08:33:37AM -0500, Axel Lin wrote:
> It is not used outside this driver so no need to make the symbol global.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks,
Guenter
