Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab0KIQ1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:27:14 -0500
Received: from imr4.ericy.com ([198.24.6.8]:58034 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab0KIQ1L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:27:11 -0500
Date: Tue, 9 Nov 2010 08:25:55 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Joe Perches <joe@perches.com>
CC: Jean Delvare <khali@linux-fr.org>, Hans de Goede <j.w.r.degoede@hhs.nl>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [01/32] drivers/hwmon/abituguru.c: Use pr_fmt and pr_<level>
Message-ID: <20101109162555.GA13340@ericsson.com>
References: <26de47ba1bd7356e5b4c2490a3377bc2860007a4.1287556801.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <26de47ba1bd7356e5b4c2490a3377bc2860007a4.1287556801.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 06:51:25AM -0000, Joe Perches wrote:
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> Added a few static strings to standardize logging messages.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> 
Applied.

Thanks,
Guenter
