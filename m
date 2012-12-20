Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752272Ab2LTFfE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 00:35:04 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:56539 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750917Ab2LTFe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 00:34:58 -0500
Date: Wed, 19 Dec 2012 21:37:57 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Durgadoss R <durgadoss.r@intel.com>
Cc: rui.zhang@intel.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, hongbo.zhang@linaro.org, wni@nvidia.com
Subject: Re: [PATCH 0/8] Thermal Framework Enhancements
Message-ID: <20121220053757.GD28007@kroah.com>
References: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355822977-4804-1-git-send-email-durgadoss.r@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 02:59:29PM +0530, Durgadoss R wrote:
> This patch is a v1 based on the RFC submitted here:
> https://patchwork.kernel.org/patch/1758921/
> 
> This patch set is based on Rui's -thermal tree, and is
> tested on a Core-i5 and an Atom netbook.
> 
> This series contains 8 patches:
> Patch 1/8: Creates new sensor level APIs
> Patch 2/8: Creates new zone level APIs. The existing tzd structure is
>            kept as such for clarity and compatibility purposes.
> Patch 3/8: Creates functions to add/remove a cdev to/from a zone. The
>            existing tcd structure need not be modified.
> Patch 4/8: Adds a thermal_trip sysfs node, which exposes various trip
>            points for all sensors present in a zone.
> Patch 5/8: Adds a thermal_map sysfs node. It is a compact representation
>            of the binding relationship between a sensor and a cdev,
>            within a zone.
> Patch 6/8: Creates Documentation for the new APIs. A new file is
>            created for clarity. Final goal is to merge with the existing
>            file or refactor the files, as whatever seems appropriate.

The documentation for sysfs files needs to be in Documentation/ABI,
please add new entries there if you are creating new sysfs files.

thanks,

greg k-h
