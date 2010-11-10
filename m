Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755380Ab0KJSGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:06:38 -0500
Received: from imr3.ericy.com ([198.24.6.13]:53549 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754069Ab0KJSGh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:06:37 -0500
Date: Wed, 10 Nov 2010 10:05:55 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 04/11] hwmon: applesmc: Introduce a register lookup
 table (rev3)
Message-ID: <20101110180555.GC18472@ericsson.com>
References: <1289386685-9988-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1289386685-9988-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 05:58:03AM -0500, Henrik Rydberg wrote:
> One main problem with the current driver is the inability to quickly
> search for supported keys, resulting in detailed feature maps per
> machine model which are cumbersome to maintain.
> 
> This patch adds a register lookup table, which enables binary search
> for supported keys. The lookup also reduces the io frequency, so the
> original mutex is replaced by locks around the actual io.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied.

Thanks,
Guenter
