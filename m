Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756254Ab1BYVrr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 16:47:47 -0500
Received: from imr3.ericy.com ([198.24.6.13]:39099 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754248Ab1BYVrp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 16:47:45 -0500
Subject: Re: [PATCH v4 2/5] hwmon: (pmbus) Add support for Maxim MAX8688
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Jonathan Cameron <jic23@cam.ac.uk>
CC: Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D681004.1060301@cam.ac.uk>
References: <1297969217-9564-1-git-send-email-guenter.roeck@ericsson.com>
	 <1297969217-9564-3-git-send-email-guenter.roeck@ericsson.com>
	 <4D681004.1060301@cam.ac.uk>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 25 Feb 2011 13:46:51 -0800
Message-ID: <1298670411.1735.112.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

On Fri, 2011-02-25 at 15:24 -0500, Jonathan Cameron wrote:
> Straight forward use of your core driver. I've not checked this against
> a datasheet, so ack assumes all the numbers are correct!
> 
I have either real hw, eval boards, or home-built boards for all
supported chips, so while I would not rule out the possibility that I
got something wrong, I have at least verified it with real hardware.

Thanks,
Guenter



