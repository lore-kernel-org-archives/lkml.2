Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2LaHXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 02:23:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:58968 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208Ab2LaHXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 02:23:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,384,1355126400"; 
   d="scan'208";a="271416955"
Date: Mon, 31 Dec 2012 15:24:26 +0800
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] staging:iio:adis16260: select IIO_ADIS_LIB to fix build
 error
Message-ID: <20121231072426.GT11568@yliu-dev.sh.intel.com>
References: <1356932195-31437-1-git-send-email-yuanhan.liu@linux.intel.com>
 <50E13BBA.1000801@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E13BBA.1000801@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 31, 2012 at 08:16:10AM +0100, Lars-Peter Clausen wrote:
> On 12/31/2012 06:36 AM, Yuanhan Liu wrote:
> > Commit 9d5e9fdf turned the code to use adis library, so it depends on
> > adis lib. But it forgot to select it at Kconfig file. Thus if adis is
> > not enabled, it will produce following build errros(catched by Fengguang's
> > 0-DAY kernel build testing system):
> >   ERROR: "adis_initial_startup" [drivers/staging/iio/gyro/adis16260.ko] undefined!
> >   ERROR: "adis_init" [drivers/staging/iio/gyro/adis16260.ko] undefined!
> >   ERROR: "adis_write_reg" [drivers/staging/iio/gyro/adis16260.ko] undefined!
> >   ERROR: "adis_read_reg" [drivers/staging/iio/gyro/adis16260.ko] undefined!
> >   ERROR: "adis_single_conversion" [drivers/staging/iio/gyro/adis16260.ko] undefined!
> > 
> > Selecting IIO_ADIS_LIB at Kconfig file fixes this issue.
> > 
> > Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> > Cc: Lars-Peter Clausen <lars@metafoo.de>
> > Cc: Jonathan Cameron <jic23@kernel.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
> 
> Hi,
> 
> Thanks. But I already sent a similar patch some time ago. See
> http://www.spinics.net/lists/linux-iio/msg07128.html


Got it, and sorry for the duplicate patch.

	--yliu
