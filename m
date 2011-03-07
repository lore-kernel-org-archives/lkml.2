Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1CGWMW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:12:22 -0500
Received: from imr3.ericy.com ([198.24.6.13]:49561 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756615Ab1CGWMT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:12:19 -0500
Date: Mon, 7 Mar 2011 14:11:29 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Greg Schnorr <gschnorr@cisco.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (pmbus) More stringent checking of VOUT_MODE
 register
Message-ID: <20110307221129.GC14789@ericsson.com>
References: <1299043940-22798-1-git-send-email-guenter.roeck@ericsson.com>
 <C99A91CB.5A89D%gschnorr@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <C99A91CB.5A89D%gschnorr@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 04:44:43PM -0500, Greg Schnorr wrote:
> Looks good, tested and works on one such VOUT_MODE poor design...
> 
> On 3/1/11 9:32 PM, "Guenter Roeck" <guenter.roeck@ericsson.com> wrote:
> 
> > Some PMBus chips do not support the VOUT_MODE register. To make matters worse,
> > such chips may not return an error when reading the register either, but
> > instead
> > return 0xff.
> > 
> > Check if the register exists using pmbus_check_byte_register() before reading
> > its value. In addition, validate the returned value and ignore it if it is
> > 0xff
> > (which is invalid).
> > 
> > Reported-by: Greg Schnorr <gschnorr@cisco.com>
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Acked-by: Greg Schnorr <gschnorr@cisco.com>
> 
Thanks!

Guenter
