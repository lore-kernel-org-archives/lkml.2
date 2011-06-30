Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751557Ab1F3OXP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 10:23:15 -0400
Received: from imr4.ericy.com ([198.24.6.8]:50660 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751218Ab1F3OXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 10:23:06 -0400
Date: Thu, 30 Jun 2011 07:22:19 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: ashishj3 <ashish.jangam@kpitcummins.com>
CC: "randy.dunlap@oracle.com" <randy.dunlap@oracle.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "dchen@diasemi.com" <dchen@diasemi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 6/11] HWMON: DA9052 hwmon driver v2
Message-ID: <20110630142219.GA13161@ericsson.com>
References: <1309439728.4656.0.camel@L-0532.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309439728.4656.0.camel@L-0532.kpit.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 09:15:27AM -0400, ashishj3 wrote:
> The DA9052 PMIC provides an Analogue to Digital Converter with 10 bits
> resolution and 10 channels.
> 
> This patch montiors the DA9052 PMIC's ADC channels mostly for battery parameters
> like battery temperature, junction temperature, battery current etc.
> 
> Signed-off-by: David Dajun Chen <dchen@diasemi.com>
> Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

I assume this patch will be handled as part of a patchset, correct ?

Thanks,
Guenter
