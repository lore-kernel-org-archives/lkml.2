Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759315Ab2GLWaP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 18:30:15 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:30387 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756397Ab2GLWaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 18:30:11 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-c7-4fff4ff1952b
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Venu Byravarasu'" <vbyravarasu@nvidia.com>, sameo@linux.intel.com,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
References: <012b01cd5f5d$b6ff8a10$24fe9e30$@com>
 <D958900912E20642BCBC71664EFECE3E6DDB1D61AC@BGMAIL02.nvidia.com>
In-reply-to: <D958900912E20642BCBC71664EFECE3E6DDB1D61AC@BGMAIL02.nvidia.com>
Subject: RE: [PATCH V3 3/7] mfd: samsung: Modify samsung mfd header
Date: Fri, 13 Jul 2012 07:30:09 +0900
Message-id: <01ed01cd607d$e4f98a30$aeec9e90$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1fXbbieHH+gCiiTPG5j4NYs10mVAAAYpkgAEZ84mA=
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jQd2P/v/9DY6vtLG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZTQ/mMBV8Y684eGclawPjD9YuRk4OCQETidd/nrFD2GISF+6t
	Z+ti5OIQEpjOKHHt0HFmkISQwFwmicsfEkFsNgENiZW737KB2CIC1RL3d3cA2RwczALBEltP
	60GUl0jc3/QLrIRTwFfizaL9YLuEBZwlzn5bAGazCKhKLJu+EczmFTCUaOjezwhhC0r8mHyP
	BcRmFtCSWL/zOBOELS+xec1bZpBVEgLqEo/+6kJcYCUxuf0vVLmIxL4X7xgnMArNQjJpFpJJ
	s5BMmoWkZQEjyypG0dSC5ILipPRcQ73ixNzi0rx0veT83E2M4CB+JrWDcWWDxSFGAQ5GJR7e
	Bx7//YVYE8uKK3MPMUpwMCuJ8K6zBwrxpiRWVqUW5ccXleakFh9ilOZgURLnNfb+6i8kkJ5Y
	kpqdmlqQWgSTZeLglGpgFExwqHT4saGk5PqXmL3+Ky7KGfBzsM1Rub5V8+4pPj7LKcLsEy95
	l32b5L6Nw6n2ReqFqzs6ZjKlMDKFMf/hSO1za0/d7rP0/8+Vh1f6d5ZuW/etwmLb60zjf753
	XvjXJroXr0kTUdtXxx2Zblzz6et3o7v7dkvdmcFr8MJm1blDPjJ343dXKbEUZyQaajEXFScC
	AIawRspeAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!
On Wednesday, July 11, 2012 9:30 PM, Venu Byravarasu wrote:

> > + * copyright (c) 2011 Samsung Electronics Co., Ltd
> > + *              http://www.samsung.com
> 
> In most of the files you mentioned 2011.
> Should they not be changed to 2012?

Most of the files are created in 2011.
This file is moved from include/linux/mfd/s5m87xx/s5m-core.h
 
> > -	int				buck_set1;
> > -	int				buck_set2;
> > -	int				buck_set3;
> 
> As you have buck4_enable etc below, by any chance do you need buck_set4 as well here?


No, S5M8767 have 3 controllerble gpios.
The purpose of buck_set1,2,3 is each gpio control.
To handle 3 gpio, I had added buck_set1, buck_set2, buck_set3.

> Similarly should you declare buck1_enable here?


No, gpio control can be enabled on buck2, buck3, buck4.
There is no need buck1_enable.

> > -	int				buck2_enable;
> > -	int				buck3_enable;
> > -	int				buck4_enable;
> > -	int				buck_default_idx;
> > -	int				buck2_default_idx;

Thanks,
Sangbeom.

