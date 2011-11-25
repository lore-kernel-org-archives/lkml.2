Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754635Ab1KYLDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 06:03:15 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37042 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1KYLDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 06:03:13 -0500
Date: Fri, 25 Nov 2011 11:03:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Donggeun Kim <dg77.kim@samsung.com>,
        Simon Guinot <sguinot@lacie.com>, Lars-Peter Clausen <lars@metafoo.de>,
        MyungJoo Ham <myungjoo.ham@samsung.com>, Ben Dooks <ben@simtec.co.uk>,
        Hans de Goede <hdegoede@redhat.com>, J Keerthy <j-keerthy@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jean Delvare <khali@linux-fr.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH] hwmon: convert drivers/hwmon/* to use
 module_platform_driver()
Message-ID: <20111125110311.GB5315@opensource.wolfsonmicro.com>
References: <1322206260.11718.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322206260.11718.4.camel@phoenix>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 03:31:00PM +0800, Axel Lin wrote:
> This patch converts the drivers in drivers/hwmon/* to use the
> module_platform_driver() macro which makes the code smaller and a bit
> simpler.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
