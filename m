Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751360Ab2FRL22 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:28:28 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:43795 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab2FRL20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:28:26 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-f6-4fdf10d93c05
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sbkim01@gmail.com
Subject: [PATCH 0/7] Initial release of Samsung S2MPS11 pmic driver
Date: Mon, 18 Jun 2012 20:28:16 +0900
Message-id: <067201cd4d45$7987d680$6c978380$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1NRXPY3hj2z6DKTvmyl1TVKKzlsg==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jQd2bAvf9DY4/ELW4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZU7fNZCy4y1Fxrm0BYwPjNPYuRk4OCQETiZsXZjND2GISF+6t
	Z+ti5OIQEpjOKHFhdQczhDOXSeL749dgVWwCGhIrd79lA7FFBHwlLr38z9rFyMHBLBAssfW0
	HkhYWMBZ4tqsFywgNouAqsS226sZQWxeAUOJbWt6mCBsQYkfk++B1TALaEms33mcCcKWl9i8
	5i0zyEgJAXWJR391QUwRAT2JuSeUICpEJPa9eMc4gVFgFpJBs5AMmoVk0CwkLQsYWVYxiqYW
	JBcUJ6XnGukVJ+YWl+al6yXn525iBAflM+kdjKsaLA4xCnAwKvHwvmG/7y/EmlhWXJl7iFGC
	g1lJhPcHF1CINyWxsiq1KD++qDQntfgQozQHi5I4b5P1BX8hgfTEktTs1NSC1CKYLBMHp1QD
	I0Nbfv75Lyv/TNF9z12RGq84Re50/ot5dzfo695yPW/oe/iHZ/WNz00iE1zKD9fHBrh5qDq4
	R+n0SaSd8EjLd3x5RPxDenXibmUbK+NpOwUE/VPMvB+4FBVu1N0/Yb7NDP+onab3KtcyJfVX
	KOUVe9e7TlGwXrdk+q8jW/raG2zCJJb/O5ykxFKckWioxVxUnAgAvSIDvUYCAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The S2MPS11 is comprised of high efficient Buck converters,
various LDOs, and an RTC and tightly coupled with Multi Core Samsung 
Application Processors, which is used in a wide variety of mobile applications
such as smart phones and tablet PCs.
S2MPS11 provide 10 high efficiency buck converters and 38 LDO regulators.
Especially, Buck2 can support 7.0A current capacity for high performance
samsung application processor.
Most of S2MPS11 feature are similar to S5M series.
and Instead of using s5m prefix, Samsung decide to use s2m prefix.
So, I try to make common mfd driver for S2M and S5M series.
Most of s5m prefix is changed into sec prefix.

[PATCH 1/7] mfd: samsung: Rename and Replace file and directory
[PATCH 2/7] regulator: s5m8767: Modify header file and Kconfig
[PATCH 3/7] mfd: samsung: Modify samsung mfd driver for common api
[PATCH 4/7] regulator: s5m8767a: Modify function and variable name
[PATCH 5/7] mfd: samsung: Modify samsung mfd header
[PATCH 6/7] regualtor: Add samsung s2mps11 regulator driver
[PATCH 7/7] mfd: s2mps11: Add samsung s2mps11 pmic

Thanks,
Sangbeom.

