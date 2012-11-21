Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab2KUJoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 04:44:14 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:31333 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752391Ab2KUJnK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 04:43:10 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-88-50aca22df0e6
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Doug Anderson'" <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org, "'Olof Johansson'" <olofj@chromium.org>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Shawn Guo'" <shawn.guo@linaro.org>,
        "'Rob Herring'" <rob.herring@calxeda.com>,
        "'Josh Cartwright'" <josh.cartwright@ni.com>,
        "'Rahul Sharma'" <rahul.sharma@samsung.com>,
        "'Arun Kumar K'" <arun.kk@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1353432158-22999-1-git-send-email-dianders@chromium.org>
 <1353432158-22999-2-git-send-email-dianders@chromium.org>
 <CAOesGMiGZHAw0zOZFZcYJ9YngbcMsTJrzhG+DQ5sP9Sq+CyzDQ@mail.gmail.com>
In-reply-to: 
Subject: RE: [PATCH 2/2] ARM: dts: snow: Add board dts file for Snow board (ARM
 Chromebook)
Date: Wed, 21 Nov 2012 18:43:08 +0900
Message-id: <0dfc01cdc7cc$9d308170$d7918450$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3HTwExOaL9MfUpTZykk07DvrvdLwAIpD/AAA1xIpA=
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zY13dRWsCDF7+47S4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo48ukKa8FplooJT18yNTAeYe5i5OSQEDCRWDSxA8oW
	k7hwbz1bFyMXh5DAMkaJSSfeMMEUTVixBCqxiFHi1p11UM5fRomdPZvZQarYBDQkDr9/BmaL
	CJRJnDlznwWkiFlgP7PEhAnPoTpOMEp8eraTEaSKU4BHYt2fTrDlwgKxEh8u/wWzWQRUJX53
	LWHtYuTg4BWwlfg2AewMXgFBiR+T77GA2MwCWhLrdx5ngrDlJTavecsMUi4hoC7x6K8uxA1W
	Es+Pr2aGKBGR2PfiHSPEdAGJb5MPsUCUy0psOsAMcpmEwDp2iV1929ghPpaUOLjiBssERolZ
	SDbPQrJ5FpLNs5CsWMDIsopRNLUguaA4KT3XUK84Mbe4NC9dLzk/dxMjJM6kdjCubLA4xCjA
	wajEw7tx7eoAIdbEsuLK3EOMEhzMSiK8m6asCRDiTUmsrEotyo8vKs1JLT7E6AN0+URmKdHk
	fGAKyCuJNzQ2NjEzMTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBcWtx54X2
	QHaXZ78S2lW5fminT/61Z3nxmiNGq3Z+abgnWrJ1xjfhqw8tmN2MD+46/fbx7stJ819/4hH4
	KxsfEHd+ifzqUzPrvlgzTtNgPGcro5Rpwrc4oUY2kP2h3qrtYlMi3jF9+mqz9UHU/RmXq/vt
	+P+vdVhw4nZPnX7r2YDe+HCW75GzJZVYijMSDbWYi4oTATXOjAjgAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV3dRWsCDPpWsFpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmHPl0hbXgNEvF
	hKcvmRoYjzB3MXJySAiYSExYsYQNwhaTuHBvPZDNxSEksIhR4taddVDOX0aJnT2b2UGq2AQ0
	JA6/fwZmiwiUSZw5c58FpIhZYD+zxIQJz6E6TjBKfHq2kxGkilOAR2Ldn06wfcICsRIfLv8F
	s1kEVCV+dy1h7WLk4OAVsJX4NoEJJMwrICjxY/I9FhCbWUBLYv3O40wQtrzE5jVvmUHKJQTU
	JR791YW4wUri+fHVzBAlIhL7XrxjnMAoNAvJpFlIJs1CMmkWkpYFjCyrGEVTC5ILipPScw31
	ihNzi0vz0vWS83M3MYKj+JnUDsaVDRaHGAU4GJV4eDeuXR0gxJpYVlyZe4hRgoNZSYR305Q1
	AUK8KYmVValF+fFFpTmpxYcYfYD+nMgsJZqcD0wweSXxhsYmZkaWRmYWRibm5jiElcR5mz1S
	AoQE0hNLUrNTUwtSi2DGMXFwSjUwlrKd6ts89XLVK83Zjkt//egRUbqkuOhz9aJlXeskg25m
	Wq6cdy/Y8vG3o7/lHRJ9f0psKZg34SVj6vSbey9ERaybapNmLdUd/dI0b3vZG+byRu+y0uUc
	n8rspQKzbz1YdFiHuzN3Lq9xTcwRYw6Ob0sO5LWHvpRMUAg84vn+Wt2Xxbv3+0wqVmIpzkg0
	1GIuKk4EAJ8Ak4sPAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kukjin Kim wrote:
> 
> Olof Johansson wrote:
> >

[...]

> >
> > Acked-by: Olof Johansson <olof@lixom.net>
> >
> > Kukjin, since your pull requests came in today, can you ack this and
> > I'll just apply it on top of your branches?
> >
> Hi Olof, yeah, I sent pull-request but there are some patches for dt and
> exynos5440 stuff in my tree not sent yet. If you're ok, let me take this
> with your ack.
> 
Applied, thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

