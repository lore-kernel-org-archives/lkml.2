Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0IPPOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:14:49 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:36234 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0IPPOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:14:48 -0400
Date: Thu, 16 Sep 2010 08:14:46 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jean Delvare <khali@linux-fr.org>, Randy Dunlap <rdunlap@xenotime.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] hwmon: (adm1031) Replace update_rate
 sysfs attribute with update_interval
Message-ID: <20100916151446.GA14229@ovro.caltech.edu>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
 <1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284602835-7605-2-git-send-email-guenter.roeck@ericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Thu, 16 Sep 2010 08:14:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 07:07:14PM -0700, Guenter Roeck wrote:
> The attribute reflects an interval, not a rate.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
> ---
>  Documentation/hwmon/sysfs-interface |   12 +++++-----
>  drivers/hwmon/adm1031.c             |   43 +++++++++++++++++++---------------
>  2 files changed, 30 insertions(+), 25 deletions(-)
> 

I'm the original author of both the update_rate text in sysfs-interface
and the adm1031 support. Your change looks good to me. Thanks for doing
the work.

Acked-by: Ira W. Snyder <iws@ovro.caltech.edu>

