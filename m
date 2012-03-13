Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757174Ab2CMHUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 03:20:01 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:1601 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab2CMHUA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 03:20:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 13 Mar 2012 00:19:59 -0700
From: Venu Byravarasu <vbyravarasu@nvidia.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
Date: Tue, 13 Mar 2012 12:49:52 +0530
Subject: RE: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Thread-Topic: [RESEND PATCH 1/2] MFD: MAX77693: add MAX77693 MFD driver
Thread-Index: Ac0A6LmB71GmYXDvRBWgsROsFLgJZAAAOPHA
Message-ID: <D958900912E20642BCBC71664EFECE3E6DD2912D3E@BGMAIL02.nvidia.com>
References: <4F5EDB01.9070308@samsung.com>
 <D958900912E20642BCBC71664EFECE3E6DD2912D02@BGMAIL02.nvidia.com>
 <CAH9JG2VrNCPMHoy5pUyc7nTzv-B7ucXheMy7PBtVUfaebt=yUA@mail.gmail.com>
 <D958900912E20642BCBC71664EFECE3E6DD2912D10@BGMAIL02.nvidia.com>
 <4F5EF376.3060909@samsung.com>
In-Reply-To: <4F5EF376.3060909@samsung.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That's fine, Thanks.

> I had plan for using regmap for i2c read/write operation on later patch.
> But I haven't yet tested max77693 driver with regmap for i2c,
> so I posted max77693 mfd driver which was tested by using i2c legacy way.
> 
> Thank you,
> Chanwoo Choi
