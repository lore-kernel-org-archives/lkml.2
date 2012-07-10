Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab2GJCLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:11:47 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:51713 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755419Ab2GJCLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:11:45 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-0f-4ffb8f5d2f98
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, sbkim01@gmail.com
References: <0ff001cd5c24$793ab100$6bb01300$@com>
 <20120709130309.GD3934@opensource.wolfsonmicro.com>
In-reply-to: <20120709130309.GD3934@opensource.wolfsonmicro.com>
Subject: RE: [PATCH V2 3/7] regulator: s5m8767: Modify function and variable
 name
Date: Tue, 10 Jul 2012 11:11:41 +0900
Message-id: <008601cd5e41$586bfe10$0943fa30$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1d0zMTV5jBXjbmTGqfwa5JAqtV5gAbZgnQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsVy+t9jQd3Y/t/+Bt/uaFtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mzl9fWQv+MFY87mxia2A8wNjFyMkhIWAi0XZ0ITOELSZx4d56
	ti5GLg4hgemMEr1PlkI5c5kk7k6dD1bFJqAhsXL3W6AEB4eIgJnEz4M8IGFmgSyJW03n2UBs
	IYF0iQtzdrOA2JwCDhIXNq0CaxUWCJZ4tHo6K4jNIqAq0f5oJ9gRvAKGEs+2X2OCsAUlfky+
	xwIxU0ti/c7jTBC2vMTmNW+ZQdZKCKhLPPqrCxIWETCSePxsHitEiYjEvhfvGCcwCs1CMmkW
	kkmzkEyahaRlASPLKkbR1ILkguKk9FwjveLE3OLSvHS95PzcTYzgMH4mvYNxVYPFIUYBDkYl
	Hl6NvN/+QqyJZcWVuYcYJTiYlUR4b7kChXhTEiurUovy44tKc1KLDzFKc7AoifOaeH/1BwZK
	YklqdmpqQWoRTJaJg1OqgXHFz+x1+0onxV6d1Pbiz5Qj/1ZeOnu06HQ178Xt7osVNxktYnr7
	z46vbLZSwoIlSeumTChlVev4Vcq2ddmRJW33dZxiKuYuUjb68Fbi8Pw7ldeLH+07ddSvVDZ0
	9f/W8+rnw1Yqb2wX2bXryJkNtlcmfz5pbSy0Re8CT2HvtMvfuDZp7eSumPfqlRJLcUaioRZz
	UXEiAPkHHoJfAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi
Monday, July 09, 2012 10:03 PM +0900, Mark Brown wrote:

> This needs to be squashed down into the patch doing the rename in the
> core to avoid build breakage.  Otherwise looks good.
Ok, I will squash and resend it.

Thanks,
Sangbeom.


