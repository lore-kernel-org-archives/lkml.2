Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455Ab2FMIZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 04:25:57 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:26022 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab2FMIZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 04:25:50 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-45-4fd84e8da50e
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        "'Liam Girdwood'" <lrg@ti.com>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com, sbkim01@gmail.com
Subject: [PATCH 0/5] Update s5m8767 regulator driver
Date: Wed, 13 Jun 2012 17:25:48 +0900
Message-id: <041e01cd493e$233a0f60$69ae2e20$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JPiJToc7eM6DxQpCQSfmtfbOb/Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMLMWRmVeSWpSXmKPExsVy+t9jAd1evxv+BnPXq1tc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Ml9eTCq6zVPx43cbewPiCuYuRk0NCwETiRFs/C4QtJnHh3nq2
	LkYuDiGBRYwSz1s3MkI4c5kkbu29xQ5SxSagIbFy91s2EFtEIExi5qyVYN3MAl4SN5rbgBo4
	OISBph5Y5QwSZhFQldi2eQcTiM0rYCixZel2KFtQ4sfke1CtWhLrdx5ngrDlJTavecsMMkZC
	QF3i0V9diE16Ep3brjFClIhI7HvxjnECo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQIDspn0jsYVzVYHGIU4GBU4uENcrvhL8SaWFZcmXuIUYKDWUmEt3jr
	dX8h3pTEyqrUovz4otKc1OJDjNIcLErivE3WF/yFBNITS1KzU1MLUotgskwcnFINjMG1zeHJ
	eWk9epNyteuet/1snv9b5PCsH3PUP+Sfa932JEWwkeVcdnqs9N0t/v+/Pkx7tOZFJNulFO38
	l1uuvPWPyz2uniO+I2aH4JnfjnJHrmyYMIvr5uEJRSzFWu71b1YYOpbO9mNbfXXGiofesmd/
	T+lWE9KNLuNmu3hCL2pJPLvr2y+L/yuxFGckGmoxFxUnAgAOlXriRgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

As samsung s5m8767a pmic is revisioned,
I update regulator driver for s5m8767a.

Revision & modification items:
- Modify ramp delay value
- Modify reset value
- Support AP watchdog reset
- Use set_voltage_sel function
- Fix the minor bug

[PATCH 1/5] regulator: Remove buck initialization in driver probing
[PATCH 2/5] regulator: Fix the problem of the division by null
[PATCH 3/5] regulator: Modify ramp_delay value
[PATCH 4/5] regulator: Replace set_voltage with set_voltage_sel
[PATCH 5/5] regulator: Support AP watchdog reset operation for s5m8767a

Thanks,
Sangbeom.

