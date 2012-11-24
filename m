Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab2KXCNg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 21:13:36 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20080 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756815Ab2KXCNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 21:13:35 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c4-50b02d4e02ff
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Cesar Eduardo Barros'" <cesarb@cesarb.net>, linux-kernel@vger.kernel.org
Cc: "'Alessandro Zummo'" <a.zummo@towertech.it>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Rob Herring'" <rob.herring@calxeda.com>, rtc-linux@googlegroups.com,
        devicetree-discuss@lists.ozlabs.org
References: <1353716808-16375-1-git-send-email-cesarb@cesarb.net>
 <1353716808-16375-22-git-send-email-cesarb@cesarb.net>
In-reply-to: <1353716808-16375-22-git-send-email-cesarb@cesarb.net>
Subject: RE: [PATCH 21/24] MAINTAINERS: fix drivers/rtc/rtc-sec.c
Date: Sat, 24 Nov 2012 11:13:28 +0900
Message-id: <000101cdc9e9$4e521ea0$eaf65be0$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3J2pCePGyNuRsZSWO2wHRLjPNsNQACjlPA
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGIsWRmVeSWpSXmKPExsVy+t8zA10/3Q0BBl/2c1hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mpgn9rAVTmCs+7jRuYNzG1MXIySEhYCLReO02K4QtJnHh3no2
	EFtIYBmjxOGnjjA1f2ftYexi5AKKT2eU+PbjMTuEM5dJonnta3aQKjYBDYmVu9+CdYsI+Ejc
	a74G1sEscJJR4k3naWaIsVUSEzfPA1vHKeAscXvLX0YQW1jAUWL6/b9gJ7EIqErsWPoEzOYV
	MJSYe2AnM4QtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+BajiATlWXePRXF+IGI4kFC5dClYtI
	7HvxjhFivIDEt8mHWCDKZSU2HWAGOVNCYBm7RPfaR9CQkJQ4uOIGywRGiVlINs9CsnkWks2z
	kKxYwMiyilE0tSC5oDgpPddQrzgxt7g0L10vOT93EyMksqR2MK5ssDjEKMDBqMTDe+Dq+gAh
	1sSy4srcQ4wSHMxKIrxfK4BCvCmJlVWpRfnxRaU5qcWHGH2ALp/ILCWanA+M+rySeENjYxMz
	E1MTc0tTc1McwkrivM0eKQFCAumJJanZqakFqUUw45g4OKUaGKvXT/p/fKeC0+ufOdcdJrj9
	uWbJ/6xHS6RBq3Tqs1tZ56bFvt3RGDjd+EbNJO2SxqMvIqa9vfR7k1OBhdJCncn/mhfssPHd
	3snz2mf1Cx8mSa6A9yovbx7oMd7xYM76zE8df7sk3kQ6qigd6PjHKNp+0TVsW33G998n+y1j
	dNjOcPYuDxFpDVFiKc5INNRiLipOBADtfzZO2QIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jQV0/3Q0BBvc+slhc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjKYJ/awFU5grPu40bmDc
	xtTFyMkhIWAi8XfWHkYIW0ziwr31bF2MXBxCAtMZJb79eMwO4cxlkmhe+5odpIpNQENi5e63
	bCC2iICPxL3ma4wgRcwCJxkl3nSeZgZJCAlUSUzcPI8VxOYUcJa4veUv2AphAUeJ6ff/gq1m
	EVCV2LH0CZjNK2AoMffATmYIW1Dix+R7LCA2s4CWxPqdx5kgbHmJzWveAtVwAJ2qLvHory7E
	DUYSCxYuhSoXkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hXnJhbXJqX
	rpecn7uJERy5z6R2MK5ssDjEKMDBqMTDe+Dq+gAh1sSy4srcQ4wSHMxKIrxfK4BCvCmJlVWp
	RfnxRaU5qcWHGH2AHp3ILCWanA9MKnkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9UgKEBNITS1Kz
	U1MLUotgxjFxcEo1ME4p/90Rf3zBvxVHjp7faBOy/nXA7FVbU/L6YuoCf+6Pq1wfeXHqoSWs
	903K9l5k+eJ4PYr934VT8Y0eK+YnepfNu6aQMGHT3eL0mQ8mZJ7yqrv10HnNnwjdTz9ivzC+
	rJK7kHzx9Oaf9V5nnBIXXneqs3pcHbLCaPMutsnVeZHRi5x+Cyx7/OadEktxRqKhFnNRcSIA
	0VS8+QkDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 9:27 AM , Cesar Eduardo Barros wrote:

> I am guessing that this was a typo for rtc-s3c. Please NACK this patch
> if I am wrong.

rtc-sec and rtc-s3c is different one.
rtc-sec is driver of Samsung mfd.
Rtc-s3c is driver of Samsung SoC.

Currently, We had just done rtc-sec coding.
It just keep on my repo.
Sooner or later, I will post rtc-sec.

Thanks,
Sangbeom.

