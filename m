Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab0KJSK4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:10:56 -0500
Received: from imr4.ericy.com ([198.24.6.8]:32956 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755593Ab0KJSKy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:10:54 -0500
Date: Wed, 10 Nov 2010 10:10:09 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/11] hwmon: applesmc: Simplify feature sysfs handling
 (rev2)
Message-ID: <20101110181009.GH18472@ericsson.com>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
 <1289315711-3011-10-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1289315711-3011-10-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 10:15:09AM -0500, Henrik Rydberg wrote:
> Given the dynamic node construction method, the setup of the
> accelerometer, light sensor and keyboard backlight sysfs nodes
> can be simplified. This patch does not contain any logic changes.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied.

Thanks,
Guenter
