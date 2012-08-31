Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2HaQFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:05:51 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58379 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754432Ab2HaQFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:05:50 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 31 Aug 2012 09:06:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>
Cc: lm-sensors@lm-sensors.org, Jean Delvare <khali@linux-fr.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (sht15) remove multiple driver registration
Message-ID: <20120831160604.GB5756@roeck-us.net>
References: <1346377579-24849-1-git-send-email-vivien.didelot@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346377579-24849-1-git-send-email-vivien.didelot@savoirfairelinux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 30, 2012 at 09:46:19PM -0400, Vivien Didelot wrote:
> Declare an array of platform_device_id, instead of registering a driver
> for each supported chip. This makes the code cleaner.
> Also add a module description.
> 
> Signed-off-by: Vivien Didelot <vivien.didelot@savoirfairelinux.com>

Applied to -next.

Thanks,
Guenter
