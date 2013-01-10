Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932638Ab3AJB3o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:29:44 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:20746 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932377Ab3AJB3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:29:43 -0500
X-AuditID: cbfee61b-b7f616d00000319b-3e-50ee1985da07
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        patches@linaro.org
References: <1355399644-29417-1-git-send-email-thomas.abraham@linaro.org>
 <1355399644-29417-2-git-send-email-thomas.abraham@linaro.org>
 <CACRpkdaQ10CgoFXtk4EyqL4LWVpsdEAdrmy5R-_Rqm5fJdqS4A@mail.gmail.com>
 <CAJuYYwTZkzCXjowhKaJ253Oji07eDdEjMvNssyL1ThWtETswSQ@mail.gmail.com>
 <017801cde453$77b03eb0$6710bc10$@samsung.com>
 <CACRpkdZKB1_1U1VZfYADwWfFpBum0Qc88kWtW37h7Z05RtSJfA@mail.gmail.com>
In-reply-to: <CACRpkdZKB1_1U1VZfYADwWfFpBum0Qc88kWtW37h7Z05RtSJfA@mail.gmail.com>
Subject: RE: [PATCH 1/3] pinctrl: exynos: add exynos5250 SoC specific data
Date: Wed, 09 Jan 2013 17:29:28 -0800
Message-id: <00df01cdeed1$f08d73b0$d1a85b10$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQJ22IaoyeydFvGJHT6/7CmrSguD5AGirMLTAWWQ2hgA6DN3AwI+W6wWAW3TBtSWswyV4A==
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFIsWRmVeSWpSXmKPExsVy+t8zY91WyXcBBh+71Swu75rDZjHj/D4m
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJeTpzFWDCJo+LgbZ4GxrtsXYycHBICJhI/dj1khLDF
	JC7cWw8WFxJYxihx/yZnFyMHWM3VNu4uRi6g8HRGiSNHX7NCOH8ZJRa+PQ/WzCagIXH4/TN2
	EFtEQE/izdcWdpAiZoHDjBKnT69ghujoY5a4NGE9C0gVp0CwRM/vf2DrhAW8JK51L2UCWcci
	oCoxeU4eSJhXwFJi7plpzBC2oMSPyffAWpkFtCTW7zzOBGHLS2xe85YZ4gMFiR1nXzOCjBER
	iJD48IwPokRcYtKDh2C3sQgISHybfIgF4jFZiU0HwC6TEFjHLvF651qoMZISB1fcYJnAKDEL
	yeZZSDbPQrJ5FpIVCxhZVjGKphYkFxQnpeca6RUn5haX5qXrJefnbmKERJj0DsZVDRaHGAU4
	GJV4eBk93wYIsSaWFVfmHmKU4GBWEuEN2Q4U4k1JrKxKLcqPLyrNSS0+xOgDdPlEZinR5Hxg
	9OeVxBsaG5uYmZiamFuampviEFYS52U89SRASCA9sSQ1OzW1ILUIZhwTB6dUA2PenPI1noul
	JDMDLE4wpS7faBzB89n/UGLltCUeAeqdISbub/69u5K6vnBpyOx5JnUCX1OYbHWXb3LZHFuy
	u/Nup4fs+28+4T8tNkxfF3L+VoZK/9Y6a/lnU7u3T5PaUxuv5KWZ1NYxWTHJUVHeSfDJtKTe
	e7PmNW2UvXFAqrb66oo5J5JlmpRYijMSDbWYi4oTAYwR+L/dAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFIsWRmVeSWpSXmKPExsVy+t9jQd1WyXcBBus2Klpc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmvJw4i7FgEkfF
	wds8DYx32boYOTgkBEwkrrZxdzFyApliEhfurQcKc3EICUxnlDhy9DUrhPOXUWLh2/OMIFVs
	AhoSh98/YwexRQT0JN58bWEHKWIWOMwocfr0CmaIjj5miUsT1rOAVHEKBEv0/P7HBmILC3hJ
	XOteygSymkVAVWLynDyQMK+ApcTcM9OYIWxBiR+T74G1MgtoSazfeZwJwpaX2LzmLTPEqQoS
	O86+ZgQZIyIQIfHhGR9EibjEpAcP2ScwCs1CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9Fwj
	veLE3OLSvHS95PzcTYzgCH4mvYNxVYPFIUYBDkYlHl5Gz7cBQqyJZcWVuYcYJTiYlUR4Q7YD
	hXhTEiurUovy44tKc1KLDzH6AP05kVlKNDkfmFzySuINjU3MjCyNzCyMTMzNcQgrifMynnoS
	ICSQnliSmp2aWpBaBDOOiYNTqoFxzbGEzgeCDdbqyi9Ovb/dOj3z4KUrGp9Wh/51nTLpXI3O
	c9WjZ/Osqw7XBx7XnbNV4ovbnKW5by+emH3g/4If929e789VqtzNfT8mvdwjX9fl2eHFHOzX
	T63+zpPDx6zw+Gbl6SXpF+0n+/lkqCfLP+84H23dv+/E5mmGTeu0UrjE3wp7aLw7qsRSnJFo
	qMVcVJwIALqL0Z4NAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Thu, Dec 27, 2012 at 5:58 PM, Kukjin Kim <kgene.kim@samsung.com>
> wrote:
> 
> > And I think, would be clear if the config could be changed like
following.
> >
> > 8<----------------------------------------------------------------------
> > From: Kukjin Kim <kgene.kim@samsung.com>
> > Subject: [PATCH] pinctrl: exynos: change PINCTRL_EXYNOS option
> >
> > Since pinctrl-exynos can support exynos4 and exynos5 so changed
> > the option name to PINCTRL_EXYNOS for more clarity.
> >
> > Cc: Thomas Abraham <Thomas.abraham@linaro.org>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
> 
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Shall I take this into the pinctrl tree?
> 
Yes, please :-)

Just note, regarding Samsung pinctrl changes in the following:
git://git.kernel.org/pub/scm/linux/kernel/git/kgene/linux-samsung.git
next/pinctrl-exynos

Thanks.

- Kukjin

