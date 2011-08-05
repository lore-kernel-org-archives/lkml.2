Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab1HERML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 13:12:11 -0400
Received: from imr4.ericy.com ([198.24.6.9]:40610 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751428Ab1HERMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 13:12:09 -0400
X-Greylist: delayed 906 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 13:12:08 EDT
Subject: Re: [PATCH] hwmon: add caseopen detection to w83627ehf driver
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Dmitry Artamonow <mad_soft@inbox.ru>
CC: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Ian Dobson <i.dobson@planet-ian.com>,
        Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1312549243-7503-1-git-send-email-mad_soft@inbox.ru>
References: <1312549243-7503-1-git-send-email-mad_soft@inbox.ru>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Fri, 5 Aug 2011 09:55:50 -0700
Message-ID: <1312563350.9971.123.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-05 at 09:00 -0400, Dmitry Artamonow wrote:
> Export caseopen alarm status into userspace for
> Winbond w83627* chips and also implement alarm clear knob.
> 
> Signed-off-by: Dmitry Artamonow <mad_soft@inbox.ru>

[ ... ]

> +static ssize_t
> +store_caseopen_clear(struct device *dev, struct device_attribute *attr,
> +			const char *buf, size_t count)

Another note: Please drop the "_clear" from the function name. It is
redundant with "store_". Another possible name would be
"clear_caseopen".

Thanks,
Guenter


