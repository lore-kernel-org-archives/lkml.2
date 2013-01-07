Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab3AGTVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:21:35 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:57265 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3AGTVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:21:33 -0500
Date: Mon, 7 Jan 2013 11:21:29 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com
Subject: Re: [PATCH 5/9] Thermal: Create 'mapX' sysfs node for a zone
Message-ID: <20130107192129.GA4465@kroah.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-6-git-send-email-durgadoss.r@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357542806-20449-6-git-send-email-durgadoss.r@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 12:43:22PM +0530, Durgadoss R wrote:
> This patch creates a thermal map sysfs node under
> /sys/class/thermal/zoneX/. This contains
> entries named map0, map1 .. mapN. Each map has the
> following space separated values:
> trip_type sensor_name cdev_name trip_mask weights

sysfs file are always "one value per file".  This seems to violate that
rule, so please rework this.

thanks,

greg k-h
