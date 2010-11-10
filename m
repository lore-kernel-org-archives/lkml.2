Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0KJSJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 13:09:30 -0500
Received: from imr4.ericy.com ([198.24.6.8]:60930 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751556Ab0KJSJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 13:09:29 -0500
Date: Wed, 10 Nov 2010 10:08:42 -0800
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 07/11] hwmon: applesmc: Extract all features
 generically (rev3)
Message-ID: <20101110180842.GF18472@ericsson.com>
References: <1289386685-9988-1-git-send-email-rydberg@euromail.se>
 <1289386685-9988-3-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1289386685-9988-3-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 10, 2010 at 05:58:05AM -0500, Henrik Rydberg wrote:
> With temperature keys being determined automatically, the dmi match
> data is only used to assign features that can easily be detected from
> the smc. This patch removes the dmi match data altogether, and reduces
> the match table to the main machine models.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Applied.

Thanks,
Guenter
