Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0H0L6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 07:58:38 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:24970 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440Ab0H0L6f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 07:58:35 -0400
Date: Fri, 27 Aug 2010 13:58:20 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>,
        "Darrick J. Wong" <djwong@us.ibm.com>, linux-doc@vger.kernel.org,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] hwmon: Add tempX_emergency attribute to sysfs ABI
Message-ID: <20100827135820.5a093229@hyperion.delvare>
In-Reply-To: <1282900309-17074-1-git-send-email-guenter.roeck@ericsson.com>
References: <1282900309-17074-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Aug 2010 02:11:49 -0700, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> v2: Re-phrased attribute description
> 
>  Documentation/hwmon/sysfs-interface |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index ff45d1f..101300b 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -310,6 +310,13 @@ temp[1-*]_crit_hyst
>  		from the critical value.
>  		RW
>  
> +temp[1-*]_emergency
> +		Temperature emergency max value, for chips supporting more than
> +		two upper temperature limits. Must be equal or greater than
> +		corresponding temp_crit values.
> +		Unit: millidegree Celsius
> +		RW
> +
>  temp[1-*]_lcrit	Temperature critical min value, typically lower than
>  		corresponding temp_min values.
>  		Unit: millidegree Celsius

Applied, thanks.

-- 
Jean Delvare
