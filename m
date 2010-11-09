Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab0KIQiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:38:23 -0500
Received: from imr4.ericy.com ([198.24.6.8]:52694 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751222Ab0KIQiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:38:21 -0500
Date: Tue, 9 Nov 2010 08:37:40 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, Luca Tettamanti <kronos.it@gmail.com>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [06/32] drivers/hwmon/asus_atk0110.c: Use pr_fmt and pr_<level>
Message-ID: <20101109163740.GA14733@ericsson.com>
References: <506bc745e46020fb99159fd73288d3b0202c99cf.1287556801.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <506bc745e46020fb99159fd73288d3b0202c99cf.1287556801.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 06:51:30AM -0000, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
Applied.

On a side note, I let the long lines go through as long as checkpatch doesn't complain.

Thanks,
Guenter
