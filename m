Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab1KQRCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 12:02:51 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:12167 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754Ab1KQRCu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 12:02:50 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 17 Nov 2011 09:02:40 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Igor Grinberg <grinberg@compulab.co.il>,
        Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Barry Song <21cnbao@gmail.com>, Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 17 Nov 2011 09:02:39 -0800
Subject: RE: [PATCH v2] pinctrl: indicate GPIO direction on single GPIO
 request
Thread-Topic: [PATCH v2] pinctrl: indicate GPIO direction on single GPIO
 request
Thread-Index: AcylPa6/7SZlJUEPS0O3q0G9UYFNcAADOTVA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74BBB@HQMAIL01.nvidia.com>
References: <1321537582-8624-1-git-send-email-linus.walleij@stericsson.com>
 <4EC52842.8020906@compulab.co.il>
In-Reply-To: <4EC52842.8020906@compulab.co.il>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Igor Grinberg wrote at Thursday, November 17, 2011 8:29 AM:
> You haven't responded to my request for the previous version...
> Pleaser, see below:
> 
> On 11/17/11 15:46, Linus Walleij wrote:
> > From: Linus Walleij <linus.walleij@linaro.org>
...
> >  static int pin_request(struct pinctrl_dev *pctldev,
> >  		       int pin, const char *function,
> > -		       struct pinctrl_gpio_range *gpio_range)
> > +		       struct pinctrl_gpio_range *gpio_range,
> > +		       bool gpio_direction)
> 
> can this (and other instances) be:
> s/gpio_direction/gpio_direction_out/
> ?
> Because "gpio_direction == true/false" does not make much sense.
> OTOH, "gpio_direction_out == true/false" does make sense.

I agree with this sentiment.

Bikeshedding a little, but is_output is shorter and just as explanatory
to me.

-- 
nvpublic

