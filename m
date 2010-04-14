Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab0DNNa5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 09:30:57 -0400
Received: from bamako.nerim.net ([62.4.17.28]:53434 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab0DNNa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 09:30:56 -0400
Date: Wed, 14 Apr 2010 15:30:52 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@linux.intel.com>
Cc: linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Various intel small device drivers
Message-ID: <20100414153052.4e07f0cc@hyperion.delvare>
In-Reply-To: <20100414124913.23181.75903.stgit@localhost.localdomain>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, 14 Apr 2010 13:51:30 +0100, Alan Cox wrote:
> These have been through my clean up processing, in particular the accelerometers
> are now using the input layer infrastructure.
> 
> 
> ---
> 
> Kalhan Trisal (4):
>       emc1403: thermal sensor support
>       liss331d1: accelerometer driver
>       isl29020: ambient light sensor
>       hmc6352: Add driver for the HMC6352 compass

The liss331d1, isl29020 and hmc6352 are not hardware monitoring drivers
and thus do not belong to drivers/hwmon.

BTW, when sending actual hardware monitoring drivers, the right mailing
list is lm-sensors, which you did not include. Please see MAINTAINERS.

>  drivers/hwmon/Kconfig    |   34 ++++
>  drivers/hwmon/Makefile   |    4 
>  drivers/hwmon/emc1403.c  |  437 ++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/hwmon/hmc6352.c  |  235 +++++++++++++++++++++++++
>  drivers/hwmon/isl29020.c |  243 ++++++++++++++++++++++++++
>  drivers/hwmon/lis331dl.c |  286 ++++++++++++++++++++++++++++++
>  6 files changed, 1239 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/hwmon/emc1403.c
>  create mode 100644 drivers/hwmon/hmc6352.c
>  create mode 100644 drivers/hwmon/isl29020.c
>  create mode 100644 drivers/hwmon/lis331dl.c
> 


-- 
Jean Delvare
