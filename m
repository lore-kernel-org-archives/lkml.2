Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757194Ab0DNXKF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 19:10:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:43764 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757163Ab0DNXKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 19:10:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,208,1270450800"; 
   d="scan'208";a="613220225"
Date: Wed, 14 Apr 2010 23:37:23 +0100
From: Alan Cox <alan@linux.intel.com>
To: =?UTF-8?B?w4lyaWM=?= Piel <E.A.B.Piel@tudelft.nl>
Cc: linux-i2c@vger.kernel.org, khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] liss331d1: accelerometer driver
Message-ID: <20100414233723.25da5af0@linux.intel.com>
In-Reply-To: <4BC63DC5.8040501@tudelft.nl>
References: <20100414124913.23181.75903.stgit@localhost.localdomain>
	<20100414125155.23181.56610.stgit@localhost.localdomain>
	<4BC63DC5.8040501@tudelft.nl>
Organization: Intel
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I wouldn't want to be too picky, if this driver works fine with your
> hardware and it's tested, why not, but from looking at the spec of
> this chip (and at the code of this driver), it looks like it could be
> completely compatible with the lis3lv02d driver (with lis3lv02d_i2c).
> Same registers, including the WHO_AM_I register which returns 0x3B
> (which is a supported version).

I will take a look in detail. The IRQ bit is different and as you say
the retries can be added to it anyway.

> 
> Have you tried and there were some specific incompatibilities? 

I am picking this project up rather than being directly responsible for
its history - chances are nobody has.

Alan
