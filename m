Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932829Ab1BYVnu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:43:50 -0500
Received: from imr4.ericy.com ([198.24.6.8]:40457 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932101Ab1BYVnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:43:49 -0500
Subject: Re: [PATCH v4 3/5] hwmon: (pmbus) Add support for Maxim MAX16064
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D681091.4030008@cam.ac.uk>
References: <1297969217-9564-1-git-send-email-guenter.roeck@ericsson.com>
	 <1297969217-9564-4-git-send-email-guenter.roeck@ericsson.com>
	 <4D681091.4030008@cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 25 Feb 2011 13:42:44 -0800
Message-ID: <1298670164.1735.108.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Fri, 2011-02-25 at 15:26 -0500, Jonathan Cameron wrote:
> Again, straight forward use of pmbus_core.  Is it actually worth having
> separate modules for each of these special cases?  Could just do the
> old big table of fixed chip info structures in a single driver...
> 
This is actually what I had originally. My reasoning to split it up was
that this makes it easier to add support for additional chips without
having to modify the core driver. Also, I can keep chip specific code
(specifically the _identify and _get_status functions) out of the core
driver.

Thanks,
Guenter


