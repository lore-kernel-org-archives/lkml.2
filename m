Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab0KEDIe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:08:34 -0400
Received: from imr3.ericy.com ([198.24.6.13]:45364 "EHLO imr3.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab0KEDId (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:08:33 -0400
Date: Thu, 4 Nov 2010 20:07:45 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Henrik Rydberg <rydberg@euromail.se>
CC: Jean Delvare <khali@linux-fr.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Subject: Re: [lm-sensors] [PATCH 7/8] hwmon: applesmc: Simplify feature
 sysfs handling
Message-ID: <20101105030745.GF28308@ericsson.com>
References: <1288511434-5662-1-git-send-email-rydberg@euromail.se>
 <1288511434-5662-8-git-send-email-rydberg@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1288511434-5662-8-git-send-email-rydberg@euromail.se>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 31, 2010 at 03:50:33AM -0400, Henrik Rydberg wrote:
> Given the dynamic node construction method, the setup of the
> accelerometer, light sensor and keyboard backlight sysfs nodes
> can be simplified. This patch does not contain any logic changes.
> 
> Signed-off-by: Henrik Rydberg <rydberg@euromail.se>

Hi Henrik,

only one minor comment.

> ---
>  drivers/hwmon/applesmc.c |  168 ++++++++++++++++++++-------------------------
>  1 files changed, 75 insertions(+), 93 deletions(-)
> 
> diff --git a/drivers/hwmon/applesmc.c b/drivers/hwmon/applesmc.c
> index 4ba20ec..c09cd2e 100644
> --- a/drivers/hwmon/applesmc.c
> +++ b/drivers/hwmon/applesmc.c

[ ... ]

> +static struct applesmc_node_group info_group[] = {
> +	{ "name", applesmc_name_show },
> +	{ "key_count", applesmc_key_count_show },
> +	{ "key_at_index", applesmc_key_at_index_show, applesmc_key_at_index_store },

Finally a checkpatch warning - line longer than 80 columns.

Guenter

