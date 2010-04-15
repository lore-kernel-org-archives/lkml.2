Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab0DOKfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:35:24 -0400
Received: from mga10.intel.com ([192.55.52.92]:13429 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752832Ab0DOKfV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:35:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,211,1270450800"; 
   d="scan'208";a="789502603"
Date: Thu, 15 Apr 2010 11:02:32 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: =?UTF-8?B?w4lyaWM=?= Piel <E.A.B.Piel@tudelft.nl>,
       linux-i2c@vger.kernel.org, khali@linux-fr.org,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] liss331d1: accelerometer driver
Message-ID: <20100415110232.7fc80ac1@linux.intel.com>
In-Reply-To: <4BC6EA64.4070308@cam.ac.uk>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414125155.23181.56610.stgit@localhost.localdomain>
	<4BC63DC5.8040501@tudelft.nl>
	<4BC6EA64.4070308@cam.ac.uk>
Organization: Intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Err. Anyone get a feeling of deja vu here?
> 
> http://lists.lm-sensors.org/pipermail/lm-sensors/2009-September/026706.html
> 
> When Kalhan originally posted this driver it was pointed out that it
> was compatible with the existing one.  A complete lack of
> communications lead to Kalhan (and someone else, might have been Eric
> or Samu, can't recall) both implementing i2c support in the driver.
> Can't find it right now but I'm fairly sure Kahlan reported that
> worked fine for this chip as well?
> 
> So looks like a lack of communications here and that Alan has picked
> up an unnecessary driver.

Thanks it does indeed - except for the retry logic which has come from
another platform source and can be submitted in turn. Only other thing I
see odd is that the existing driver prints a scary error message when
there is no IRQ rather than just an info message.

Alan
