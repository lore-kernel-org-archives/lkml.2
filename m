Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab1HXR00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 13:26:26 -0400
Received: from imr4.ericy.com ([198.24.6.9]:42088 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752697Ab1HXR0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 13:26:25 -0400
Subject: Re: [lm-sensors] [PATCH 5/6] hwmon/mc13783-adc: convert to mc13xxx
 API
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
In-Reply-To: <1314192505-23499-5-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20110824132740.GA28197@pengutronix.de>
	 <1314192505-23499-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1314192505-23499-5-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Wed, 24 Aug 2011 10:25:27 -0700
Message-ID: <1314206727.3841.3.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-24 at 09:28 -0400, Uwe Kleine-König wrote:
> The mc13783_... functions are going to be removed, so switch to the
> more generic API.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>


