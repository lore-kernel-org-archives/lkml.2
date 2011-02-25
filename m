Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932962Ab1BYUYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 15:24:12 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:60959 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932855Ab1BYUYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 15:24:10 -0500
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4D681004.1060301@cam.ac.uk>
Date: Fri, 25 Feb 2011 20:24:36 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Guenter Roeck <guenter.roeck@ericsson.com>
CC: Jean Delvare <khali@linux-fr.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg Schnorr <gschnorr@cisco.com>,
        lm-sensors@lm-sensors.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/5] hwmon: (pmbus) Add support for Maxim MAX8688
References: <1297969217-9564-1-git-send-email-guenter.roeck@ericsson.com> <1297969217-9564-3-git-send-email-guenter.roeck@ericsson.com>
In-Reply-To: <1297969217-9564-3-git-send-email-guenter.roeck@ericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Straight forward use of your core driver. I've not checked this against
a datasheet, so ack assumes all the numbers are correct!

On 02/17/11 19:00, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

