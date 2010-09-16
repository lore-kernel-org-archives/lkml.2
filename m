Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164Ab0IPPTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 11:19:33 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:39991 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab0IPPTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 11:19:31 -0400
Date: Thu, 16 Sep 2010 17:19:21 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] hwmon: (lm95241) Replace rate sysfs attribute with
 update_interval
Message-ID: <20100916171921.0410aad7@hyperion.delvare>
In-Reply-To: <1284602835-7605-3-git-send-email-guenter.roeck@ericsson.com>
References: <1284602835-7605-1-git-send-email-guenter.roeck@ericsson.com>
	<1284602835-7605-3-git-send-email-guenter.roeck@ericsson.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 19:07:15 -0700, Guenter Roeck wrote:
> update_interval is the matching attribute defined in the hwmon sysfs ABI.
> Use it.
> 
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>

Applied, thanks.


-- 
Jean Delvare
