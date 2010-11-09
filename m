Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770Ab0KIS6d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:58:33 -0500
Received: from imr3.ericy.com ([198.24.6.13]:56576 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab0KIS6b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:58:31 -0500
Subject: Re: [PATCH 03/11] drivers/hwmon/applesmc.c: Use pr_fmt and
 pr_<level>
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
In-Reply-To: <1289315711-3011-4-git-send-email-rydberg@euromail.se>
References: <1289315711-3011-1-git-send-email-rydberg@euromail.se>
	 <1289315711-3011-4-git-send-email-rydberg@euromail.se>
Content-Type: text/plain; charset="UTF-8"
Organization: Ericsson
Date: Tue, 9 Nov 2010 10:57:46 -0800
Message-ID: <1289329066.22931.214.camel@groeck-laptop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 10:15 -0500, Henrik Rydberg wrote:
> From: Joe Perches <joe@perches.com>
> 
> Added #define pr_fmt KBUILD_MODNAME ": " fmt
> Converted printks to pr_<level>
> Coalesced any long formats
> Removed prefixes from formats
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied (replacing Joe's original patch).

Thanks,
Guenter


