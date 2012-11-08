Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2KHEt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 23:49:56 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:14749 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754563Ab2KHEty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 23:49:54 -0500
X-AuditID: cbfee61b-b7f616d00000319b-b4-509b39eb5f55
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Bartlomiej Zolnierkiewicz'" <b.zolnierkie@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, jassisinghbrar@gmail.com,
        vinod.koul@intel.com, rob.herring@calxeda.com, dinguyen@altera.com,
        pawel.moll@arm.com, t.figa@samsung.com, kyungmin.park@samsung.com
References: <1351504796-24788-1-git-send-email-b.zolnierkie@samsung.com>
 <1351504796-24788-3-git-send-email-b.zolnierkie@samsung.com>
 <508EBBB6.2090006@samsung.com> <201210300956.23102.b.zolnierkie@samsung.com>
In-reply-to: <201210300956.23102.b.zolnierkie@samsung.com>
Subject: RE: [PATCH 2/4] ARM: EXYNOS: PL330 MDMA1 fix for revision 0 of
 Exynos4210 SOC
Date: Thu, 08 Nov 2012 13:49:47 +0900
Message-id: <0cea01cdbd6c$7ace7200$706b5600$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac22fInvpqJjDd6qTe+lUR/WlebNlgG724mg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zA93XlrMDDL5csrG4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mro+LOFqWAeT0XbgZdsDYxLuboYOTkkBEwkfrzdzQ5h
	i0lcuLeerYuRi0NIYBmjxKYTG5hgiiZMfc0KYgsJTGeUONjhDlH0l1Fi3/a1bCAJNgENicPv
	n4FNEhGwkng84yw7SBGzwAQmiRWrz7NAdFxjlOj/spoFpIoTqOr+1GPMILawQITEwwvfwFaw
	CKhK9B77AxbnFbCV6HqyjxHCFpT4MfkeWC+zgJbE+p3HmSBseYnNa94C1XMAnaou8eivLogp
	ImAk8e5sOUSFiMS+F+8YIaYLSHybfIgFolpWYtMBZpDLJATWsUtM+n2OEeJhSYmDK26wTGCU
	mIVk8Swki2chWTwLyYoFjCyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MUKiTHoH46oGi0OM
	AhyMSjy8GpKzA4RYE8uKK3MPMUpwMCuJ8E45MitAiDclsbIqtSg/vqg0J7X4EKMP0OUTmaVE
	k/OBCSCvJN7Q2NjEzMTUxNzS1NwUh7CSOG+zR0qAkEB6YklqdmpqQWoRzDgmDk6pBsa5t+aq
	uk+wndQS+j+LP1ZlYltRYmPRxgkyG3Q04gXXBIZMMmMWUjy3V++RlItA359PjBVcO1ZPifge
	rCTPKOnoUp2w/9WuRQrXpZUzz/ypYa4TfF4pev1LzK6eKQ+Er8V8Wv1G7fWm52/jv/1RL02S
	Oj9hubH1p4dbTOpeCc+Rmfgn7VHS14NKLMUZiYZazEXFiQCI/jiL3wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNIsWRmVeSWpSXmKPExsVy+t9jQd3XlrMDDPoOWVpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmdPzZwlQwj6ei
	7cBLtgbGpVxdjJwcEgImEhOmvmaFsMUkLtxbzwZiCwlMZ5Q42OHexcgFZP9llNi3fS1Ygk1A
	Q+Lw+2fsILaIgJXE4xln2UGKmAUmMEmsWH2eBaLjGqNE/5fVLCBVnEBV96ceYwaxhQUiJB5e
	+Aa2jkVAVaL32B+wOK+ArUTXk32MELagxI/J98B6mQW0JNbvPM4EYctLbF7zFqieA+hUdYlH
	f3VBTBEBI4l3Z8shKkQk9r14xziBUWgWkkGzkAyahWTQLCQtCxhZVjGKphYkFxQnpeca6RUn
	5haX5qXrJefnbmIEx/Az6R2MqxosDjEKcDAq8fBqSM4OEGJNLCuuzD3EKMHBrCTCO+XIrAAh
	3pTEyqrUovz4otKc1OJDjD5Af05klhJNzgeml7ySeENjEzMjSyMzCyMTc3McwkrivM0eKQFC
	AumJJanZqakFqUUw45g4OKUaGKUvz+fcxTPnZoWrxYz2tx8287BVtP8rPnNzSndpOMvc0rIo
	z2P/+Z9ft3/Lbqvun28mKRg/te/Rn89JrOsncuqLuzX0X7s363FwaNs2ts0//qh++bz0O3Pi
	Qz6TRQeW/X/oe/7hprhJ3OKpd3PlTx+8JiX4QSqMVepZTNobte9avzdeFwxcIqHEUpyRaKjF
	XFScCACdABwMDgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> 
> > Hmm...above change and adding definition of EXYNOS_PA_S_MDMA1 address
> > can fix the problem you commented on EXYNOS4210 Rev0 without others?...
> 
> The problem is affecting only EXYNOS4210 Rev0 and the fix is applied only
> for case when soc_is_exynos4210() && samsung_rev() == EXYNOS4210_REV_0,
> or did you mean something else?
> 
Yeah, I know. I mean just adding secure mdma1 address is enough for
exynos4210 rev0.

8<-----
@@ -275,6 +275,9 @@ static int __init exynos_dma_init(void)
 		exynos_pdma1_pdata.nr_valid_peri =
 			ARRAY_SIZE(exynos4210_pdma1_peri);
 		exynos_pdma1_pdata.peri_id = exynos4210_pdma1_peri;
+
+		if (samsung_rev() == EXYNOS4210_REV_0)
+			exynos_mdma1_device.res.start = EXYNOS4_PA_S_MDMA1;
 	} else if (soc_is_exynos4212() || soc_is_exynos4412()) {
 		exynos_pdma0_pdata.nr_valid_peri =
 			ARRAY_SIZE(exynos4212_pdma0_peri);
diff --git a/arch/arm/mach-exynos/include/mach/map.h
b/arch/arm/mach-exynos/include/mach/map.h
index 8480849..0abfe78 100644
--- a/arch/arm/mach-exynos/include/mach/map.h
+++ b/arch/arm/mach-exynos/include/mach/map.h
@@ -90,6 +90,7 @@
 
 #define EXYNOS4_PA_MDMA0		0x10810000
 #define EXYNOS4_PA_MDMA1		0x12850000
+#define EXYNOS4_PA_S_MDMA1		0x12840000
 #define EXYNOS4_PA_PDMA0		0x12680000
 #define EXYNOS4_PA_PDMA1		0x12690000
 #define EXYNOS5_PA_MDMA0		0x10800000
8<----

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

