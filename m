Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab0IQKhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 06:37:34 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:31591 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062Ab0IQKhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 06:37:33 -0400
Date: Fri, 17 Sep 2010 12:37:12 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        "Ira W. Snyder" <iws@ovro.caltech.edu>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] hwmon: (adm1031) Replace update_rate sysfs
 attribute with update_interval
Message-ID: <20100917123712.3c44235c@hyperion.delvare>
In-Reply-To: <1284652197-17069-1-git-send-email-guenter.roeck@ericsson.com>
References: <1284652197-17069-1-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 16 Sep 2010 08:49:57 -0700, Guenter Roeck wrote:
> The attribute reflects an interval, not a rate.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>
> ---
> v2: Modified sysfs-interface text
> 
>  Documentation/hwmon/sysfs-interface |    9 +++----
>  drivers/hwmon/adm1031.c             |   43 +++++++++++++++++++---------------
>  2 files changed, 28 insertions(+), 24 deletions(-)
> 

Applied, thanks.

-- 
Jean Delvare
