Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889Ab1K0Jfl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 04:35:41 -0500
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:49542
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750939Ab1K0Jfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 04:35:38 -0500
Message-ID: <4ED2045E.7010206@compulab.co.il>
Date: Sun, 27 Nov 2011 11:35:26 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.17) Gecko/20110824 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 1/2] gpiolib: introduce gpio_set_pullup
References: <1322230120-14120-1-git-send-email-plagnioj@jcrosoft.com> <20111125153409.GA4975@sirena.org.uk>
In-Reply-To: <20111125153409.GA4975@sirena.org.uk>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/11 17:34, Mark Brown wrote:
> On Fri, Nov 25, 2011 at 03:08:39PM +0100, Jean-Christophe PLAGNIOL-VILLARD wrote:
> 
>> +/**
>> + * gpio_set_pullup - sets @pullup for a @gpio
>> + * @gpio: the gpio to set pullup
>> + * @pullup: pullup level
>> + */
>> +int gpio_set_pullup(unsigned gpio, unsigned pullup)
> 
> This has some overlap with the pinmux subsystem.  We also need
> documentation of what the pullup values mean.

+1

AFAIK, 3 values are there: up, down and highz
Also, IMO, this should have no effect if the GPIO is configured for output.


-- 
Regards,
Igor.
