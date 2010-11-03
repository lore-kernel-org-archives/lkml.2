Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277Ab0KCNt0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:49:26 -0400
Received: from imr4.ericy.com ([198.24.6.8]:51063 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab0KCNtZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:49:25 -0400
Date: Wed, 3 Nov 2010 06:48:33 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 0/8] hwmon: applesmc: Dynamic
 configuration rewrite
Message-ID: <20101103134833.GA12700@ericsson.com>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 03:50:26AM -0400, Henrik Rydberg wrote:
> The amount of machines supported by this driver has increased rapidly
> over the past years, and the detailed driver support of the many
> flavors is quickly becoming a problem.
> 
> This patchset introduces dynamic configuration by making the SMC
> register set efficiently searchable, and fixes a number of outstanding
> issues:
> 
> * Support for all new models since MacbookPro 6.
> * Support for variable number of cpu sensors in the MacPros.
> * Handles the odd temperature sensor types found on new models.
> * Fixes minor read problems on many intermediate models.
> 
> The first patch is preparatory. The second patch adds the register
> lookup cache. The third patch adds the dynamic temperature files, and
> the fourth implements a new temperature register format. The fifth
> patch makes the remaining features dynamically configured, and the
> sixth patch sets up the fans dynamically. The seventh patch is purely
> janitory, and the last patch updates the copyright.
> 
> As a side-effect, the file is reduced by almost five hundred lines.
> 
Henrik,

since you applied your changes on top of Joe's pr_fmt patch, I assume
that you Ack that patch. Is that a correct assumption ?

I know you sent an Ack earlier, but it was "except for comments already made",
so this is just for clarification.

Thanks,
Guenter
