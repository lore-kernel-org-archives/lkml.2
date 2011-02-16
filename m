Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910Ab1BPPKD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:10:03 -0500
Received: from imr4.ericy.com ([198.24.6.8]:59679 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1BPPKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:10:00 -0500
Date: Wed, 16 Feb 2011 07:09:16 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Clemens Ladisch <clemens@ladisch.de>
CC: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 1/3] hwmon: (jc42) fix type mismatch
Message-ID: <20110216150916.GA14076@ericsson.com>
References: <4D5BCA87.7010204@ladisch.de>
 <4D5BCABD.1060106@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D5BCABD.1060106@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 08:01:49AM -0500, Clemens Ladisch wrote:
> In set_temp_crit_hyst(), make the variable 'val' have the correct
> type for strict_strtoul().
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Applied.

Thanks,
Guenter
