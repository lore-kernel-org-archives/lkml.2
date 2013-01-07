Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab3AGTYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 14:24:20 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42355 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab3AGTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 14:24:18 -0500
Date: Mon, 7 Jan 2013 11:24:14 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, eduardo.valentin@ti.com,
        hongbo.zhang@linaro.org, wni@nvidia.com
Subject: Re: [PATCH 7/9] Thermal: Make PER_ZONE values configurable
Message-ID: <20130107192414.GC4465@kroah.com>
References: <1357542806-20449-1-git-send-email-durgadoss.r@intel.com>
 <1357542806-20449-8-git-send-email-durgadoss.r@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357542806-20449-8-git-send-email-durgadoss.r@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 12:43:24PM +0530, Durgadoss R wrote:
> This patch makes MAX_SENSORS_PER_ZONE and
> MAX_CDEVS_PER_ZONE values configurable. The
> default value is 1, and range is 1-12.

Why would we ever want to change this?  Why make this configurable at
all, how is a distro supposed to set this value?

Shouldn't it be specified from the driver itself?

thanks,

greg k-h
