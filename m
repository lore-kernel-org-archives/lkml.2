Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050Ab1BPPKj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 10:10:39 -0500
Received: from imr3.ericy.com ([198.24.6.13]:36153 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751278Ab1BPPKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 10:10:36 -0500
Date: Wed, 16 Feb 2011 07:09:55 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Clemens Ladisch <clemens@ladisch.de>
CC: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 2/3] hwmon: (jc42) more helpful
 documentation
Message-ID: <20110216150955.GB14076@ericsson.com>
References: <4D5BCA87.7010204@ladisch.de>
 <4D5BCAD0.4080204@ladisch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4D5BCAD0.4080204@ladisch.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 08:02:08AM -0500, Clemens Ladisch wrote:
> The documentation lists standard numbers and chip names in excruciating
> detail, but that's all it does.  To help mere mortals in deciding
> whether to enable this driver, mention what this sensor is for and in
> which systems it might be found.
> 
> Also add a link to the actual JC 42.4 specification.
> 
> Signed-off-by: Clemens Ladisch <clemens@ladisch.de>

Applied.

Thanks,
Guenter
