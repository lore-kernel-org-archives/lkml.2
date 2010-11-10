Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0KJSIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:08:18 -0500
Received: from imr4.ericy.com ([198.24.6.8]:46080 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754366Ab0KJSIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:08:17 -0500
Date: Wed, 10 Nov 2010 10:07:31 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 05/11] hwmon: applesmc: Dynamic creation of temperature
 files (rev3)
Message-ID: <20101110180731.GD18472@ericsson.com>
References: <1289386685-9988-1-git-send-email-rydberg@euromail.se>
 <1289386685-9988-2-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1289386685-9988-2-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 05:58:04AM -0500, Henrik Rydberg wrote:
> The current driver creates temperature files based on a list
> of temperature keys given per device. Apart from slow adaption
> to new machine models, the number of sensors also depends on
> the number of processors. This patch looks up the temperature
> keys dynamically, thereby supporting all models.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied.

Thanks,
Guenter
