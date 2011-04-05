Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1DETXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 15:23:17 -0400
Received: from kroah.org ([198.145.64.141]:33444 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab1DETXP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 15:23:15 -0400
Date: Tue, 5 Apr 2011 12:21:30 -0700
From: Greg KH <greg@kroah.com>
To: cliff.cai@analog.com
Cc: gregkh@suse.de, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        jic23@cam.ac.uk, device-drivers-devel@blackfin.uclinux.org
Subject: Re: [PATCH 1/2] staging: IIO driver for Analog Devices Digital
 Output Gyroscope ADXRS450
Message-ID: <20110405192130.GA10106@kroah.com>
References: <1301025958-2175-1-git-send-email-cliff.cai@analog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1301025958-2175-1-git-send-email-cliff.cai@analog.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:05:57PM +0800, cliff.cai@analog.com wrote:
> From: Cliff Cai <cliff.cai@analog.com>
> 
> Add new IIO driver for Analog Devices digital output gyroscope ADXRS450
> 
> Signed-off-by: Cliff Cai <cliff.cai@analog.com>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>

This breaks the build:
  CC [M]  drivers/staging/iio/gyro/adxrs450_core.o
drivers/staging/iio/gyro/adxrs450_core.c:329:70: error: expected ‘)’ before numeric constant
drivers/staging/iio/gyro/adxrs450_core.c:337:3: error: ‘iio_dev_attr_gyro_z_quadrature_correction_raw’ undeclared here (not in a function)
drivers/staging/iio/gyro/adxrs450_core.c:216:16: warning: ‘adxrs450_read_quad’ defined but not used

Please test your patches before you send them out, it wastes everyone's
time when you don't :(

thanks,

greg k-h
