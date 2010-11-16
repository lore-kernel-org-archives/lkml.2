Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192Ab0KPVUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:20:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:58700 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759015Ab0KPVUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:20:19 -0500
Date: Tue, 16 Nov 2010 13:18:54 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.37rc2 and huge oldconfig warning
Message-Id: <20101116131854.6f39ac05.randy.dunlap@oracle.com>
In-Reply-To: <201011162028.23202.a.miskiewicz@gmail.com>
References: <201011162028.23202.a.miskiewicz@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Nov 2010 20:28:23 +0100 Arkadiusz Miskiewicz wrote:

> 
> Warning which looks like this:
> 
> [arekm@carme-pld ~/.GIT/linux-2.6]$ make oldconfig
> scripts/kconfig/conf --oldconfig Kconfig
> warning: (MEDIA_TUNER && MEDIA_SUPPORT && VIDEO_MEDIA && I2C && !MEDIA_TUNER_CUSTOMISE || VIDEO_CX23885 && MEDIA_SUPPORT && 
> VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && DVB_CORE && VIDEO_DEV && PCI && I2C && INPUT && IR_CORE && !MEDIA_TUNER_CUSTOMISE || VIDEO_AU0828 && 
> MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && I2C && INPUT && DVB_CORE && USB && VIDEO_V4L2 && !MEDIA_TUNER_CUSTOMISE || VIDEO_CX231XX_DVB && 
> MEDIA_SUPPORT && VIDEO_CAPTURE_DRIVERS && VIDEO_V4L2 && V4L_USB_DRIVERS && USB && VIDEO_CX231XX && DVB_CORE && !DVB_FE_CUSTOMISE || 
> DVB_USB_DIB0700 && MEDIA_SUPPORT && DVB_CAPTURE_DRIVERS && DVB_CORE && DVB_USB && !MEDIA_TUNER_CUSTOMISE || VIDEO_TM6000 && STAGING && 
> !STAGING_EXCLUDE_BUILD && VIDEO_DEV && I2C && INPUT && IR_CORE && USB && EXPERIMENTAL) selects MEDIA_TUNER_XC5000 which has unmet direct dependencies 
> (MEDIA_SUPPORT && MEDIA_TUNER_CUSTOMISE && VIDEO_MEDIA && I2C)

[snip]

Hi,

This huge warning list is pretty well known.  There are a few patches floating
around for it, but not merged yet...


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
