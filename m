Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab1CGWK2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 17:10:28 -0500
Received: from imr3.ericy.com ([198.24.6.13]:49431 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab1CGWK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 17:10:27 -0500
Date: Mon, 7 Mar 2011 14:08:39 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Greg Schnorr <gschnorr@cisco.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] hwmon: (pmbus) Improve support for paged fans
Message-ID: <20110307220839.GB14789@ericsson.com>
References: <1299341303-32570-1-git-send-email-guenter.roeck@ericsson.com>
 <C99A914D.5A89C%gschnorr@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <C99A914D.5A89C%gschnorr@cisco.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07, 2011 at 04:42:37PM -0500, Greg Schnorr wrote:
> Verified this patch works as expected on such "fan rich" hardware...
> 
> On 3/5/11 8:08 AM, "Guenter Roeck" <guenter.roeck@ericsson.com> wrote:
> 
> > So far, it seemed like fans would either all be in page 0, or that
> > there would be one page per fan.
> > 
> > Turns out this was a wrong assumption. There is at least one PMBus
> > fan controller which supports three pages with four fans each.
> > Update code to handle this situation.
> > 
> > Reported-by: Greg Schnorr <gschnorr@cisco.com>
> > Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Acked-by: Greg Schnorr <gschnorr@cisco.com>
> 
Thanks!

Guenter
