Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab0HZQKb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 12:10:31 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41172 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754264Ab0HZQK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 12:10:28 -0400
X-Sasl-enc: tBOgLF3llKuL19/mZwcDnO9axZFvByceGf3o9m2vHDkZ 1282839027
Date: Thu, 26 Aug 2010 13:10:23 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
        Randy Dunlap <rdunlap@xenotime.net>, linux-i2c@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: Add tempX_emergency to sysfs ABI
Message-ID: <20100826161022.GA1383@khazad-dum.debian.net>
References: <1282838085-7210-1-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282838085-7210-1-git-send-email-guenter.roeck@ericsson.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Aug 2010, Guenter Roeck wrote:
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
> tempX_emergency will be used by max6696. It can also be used for other chips
> supporting three upper temperature limits.
> 
>  Documentation/hwmon/sysfs-interface |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/hwmon/sysfs-interface b/Documentation/hwmon/sysfs-interface
> index ff45d1f..1ceb2b9 100644
> --- a/Documentation/hwmon/sysfs-interface
> +++ b/Documentation/hwmon/sysfs-interface
> @@ -310,6 +310,12 @@ temp[1-*]_crit_hyst
>  		from the critical value.
>  		RW
>  
> +temp[1-*]_emergency
> +		Temperature emergency value, typically greater than
> +		corresponding temp_crit values.
> +		Unit: millidegree Celsius
> +		RW
> +

If we have two-level alarms: critical, then emergency, it is best to have
that written down than to imply it by "typically greater than corresponding
temp_crit"...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
