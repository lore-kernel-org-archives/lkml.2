Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030253Ab2KVUAf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:00:35 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:28527 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752797Ab2KVUA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:00:27 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-0b-50adbd0112bd
From: Seungwon Jeon <tgih.jun@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>
Cc: linux-samsung-soc@vger.kernel.org,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Olof Johansson'" <olof@lixom.net>, "'Arnd Bergmann'" <arnd@arndb.de>,
        "'Will Newton'" <will.newton@imgtec.com>,
        "'Chris Ball'" <cjb@laptop.org>,
        "'Jaehoon Chung'" <jh80.chung@samsung.com>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1353535387-32106-1-git-send-email-dianders@chromium.org>
 <1353535387-32106-2-git-send-email-dianders@chromium.org>
 <000701cdc852$a5e4a130$f1ade390$%jun@samsung.com>
 <CAD=FV=Xz_nQSLqoR7TSd8vn5No9+TVa9q-hp1i0BpgUK=G3EoQ@mail.gmail.com>
In-reply-to: <CAD=FV=Xz_nQSLqoR7TSd8vn5No9+TVa9q-hp1i0BpgUK=G3EoQ@mail.gmail.com>
Subject: RE: [PATCH 2/2] mmc: dw_mmc: Handle wp-gpios from device tree
Date: Thu, 22 Nov 2012 14:49:52 +0900
Message-id: <000e01cdc875$314ea960$93ebfc20$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3Iapg/OdXcFiTzSb+F6ap/39YnxAACHwHw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMIsWRmVeSWpSXmKPExsVy+t8zY13GvWsDDLquslpc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjFZZOSmpNZllqkb5fAlfG48xFrwUquio1nDzI3MLZwdDFyckgImEgs
	/rCRBcIWk7hwbz1bFyMXh5DAMkaJ3TcvM8MU/Wn+BZWYzijx8s8sRgjnD6NE7+adTCBVbAJa
	En/fvAHrEBHQlnj5YCUzSBGzwEcmic6f7exwHZsPQFRxCgRLzL7zEmy5sICbxOqjKxlBbBYB
	VYk5LY/A4rwCthIzZ51ihbAFJX5MvgcWZxbQk/j45zYjhC0vsXnNW6CZHEC3qks8+qsLcYSR
	xK8b3awQJSIS+168gxovIPFt8iEWiHJZiU0HwO6UEFjFLtHxfTI0LCQlDq64wTKBUWIWks2z
	kGyehWTzLCQrFjCyrGIUTS1ILihOSs811CtOzC0uzUvXS87P3cQIiTmpHYwrGywOMQpwMCrx
	8Go6rw0QYk0sK67MPcQowcGsJMK7qAAoxJuSWFmVWpQfX1Sak1p8iNEH6PKJzFKiyfnAdJBX
	Em9obGxiZmJqYm5pam6KQ1hJnLfZIyVASCA9sSQ1OzW1ILUIZhwTB6dUA+O2SpOIxe/Y8g4G
	nOZcxC+zSChARu5d7bVTVod8OeV2ep/7KfzF+OUN9hsrvvvNuBAd73/7xKsvVp/dV5+bMu+H
	1YRE3sfPStcUlXcKWsVc//M7fY/rr/uC2/q3/r959sEcRdfoo9O37uTlcjsQ9d/gjMDsKY67
	H9zuVmhTPqWhv1zgqqDRCelfSizFGYmGWsxFxYkA68V4o+YCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoC7j3rUBBlevMVpc3jWHzeLI/35G
	ixnn9zE5MHt83iQXwBjVwGiTkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ib
	aqvk4hOg65aZAzRfSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYx5jxuPMR
	a8FKroqNZw8yNzC2cHQxcnJICJhI/Gn+xQZhi0lcuLceyObiEBKYzijx8s8sRgjnD6NE7+ad
	TCBVbAJaEn/fvGEGsUUEtCVePljJDFLELPCRSaLzZzs7XMfmAxBVnALBErPvvGQBsYUF3CRW
	H13JCGKzCKhKzGl5BBbnFbCVmDnrFCuELSjxY/I9sDizgJ7Exz+3GSFseYnNa94CzeQAulVd
	4tFfXYgjjCR+3ehmhSgRkdj34h3jBEahWUgmzUIyaRaSSbOQtCxgZFnFKJpakFxQnJSea6hX
	nJhbXJqXrpecn7uJERzRz6R2MK5ssDjEKMDBqMTDq+m8NkCINbGsuDL3EKMEB7OSCO+iAqAQ
	b0piZVVqUX58UWlOavEhRh+gRycyS4km5wOTTV5JvKGxiZmRpZGZhZGJuTkOYSVx3maPlAAh
	gfTEktTs1NSC1CKYcUwcnFINjI78jSFOIX5hX7LeZy77bLYyX+L9Wr4F89iVsiveWvlkS5a8
	NIuTm9p81JSr+/icTT3fApfOW6bs9Ozj4ou3iqSmHW2sPPZR7pZGW4D7xj93n0zd6b9sieyb
	rlPmtbV7nZRdXKZkSZiIdS2bN8PzUkHKwszU4wrzjB/naC2pVUnkL++qNYk9qsRSnJFoqMVc
	VJwIAKfGeJIVAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 22, 2012, Doug Anderson <dianders@chromium.org> wrote:
> On Wed, Nov 21, 2012 at 5:42 PM, Seungwon Jeon <tgih.jun@samsung.com> wrote:
> > Hi,
> >
> > wp-gpios has been implemented in dw_mmc-exynos.c
> > It can be reused for EXYNOS platform? We need to modify some though.
> 
> Yup, I've seen that.  Patch 1/2 ("mmc: dw_mmc: exynos: Stop claiming
> wp-gpio") addressed that.  For some reason I can't find that on
> LKML.org yet.  Strange.  :-/  I'll forward it on to you shortly.
> 
> In any case: I found that the exynos code didn't actually work.  It
> claimed the GPIO but didn't ever look at it.
> 
> I have the beginnings of the code to implement this properly in the
> exynos code but I stopped working on it when I decided that other SoCs
> could also benefit from the code and it fit better in the general
> dw_mmc driver.
> 
> If you disagree and would like me to cleanup the version of this patch
> that's just in the exynos driver and post that, I will.  Just let me
> know.
Yes, origin code of dw_mmc-exynos didn't work fine. We need to modify it.
Anyway, some problem in mailing? I didn't get 1/2 of patch.
In addition, it's not found in any mail-archive. After resolved, I can review.

Thanks, 
Seungwon Jeon
> 
> 
> Thanks for the review!
> 
> -Doug

