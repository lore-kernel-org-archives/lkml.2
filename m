Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754063Ab2LCJat (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:30:49 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:61932 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729Ab2LCJas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:30:48 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-2e-50bc6c0a273b
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Axel Lin'" <axel.lin@ingics.com>
Cc: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org
References: <1354027788.13128.1.camel@phoenix>
 <CAJuYYwRdBdi+gG944ZcJk8xF6hLUD165iX0oLn9HWeyo3od+hA@mail.gmail.com>
In-reply-to: <CAJuYYwRdBdi+gG944ZcJk8xF6hLUD165iX0oLn9HWeyo3od+hA@mail.gmail.com>
Subject: RE: [PATCH] pinctrl: exynos5440/samsung: Staticize pcfgs
Date: Mon, 03 Dec 2012 18:08:26 +0900
Message-id: <1f6a01cdd135$c11149e0$4333dda0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3RNZSWcrp9VFjzQzK6GTZj9hC7YQAAB28Q
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t8zA12unD0BBrOX61lc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M9a8Osxes46hY+foaWwPjS7YuRk4OCQETiQ2rzrBD2GISF+6t
	B4pzcQgJLGOU6D+6E8jhACt60poAEZ/OKPHgyCRmCGcek8SM36fBJrEJaEgcfv8MbJKIQIjE
	+ZfrmUFsZoFqiUdda1lAbCGBUol/Pw+zggzlFAiWeHc0BMQUFnCUeL9CDaSCRUBV4vrKDkYQ
	m1fAVmLTrs+sELagxI/J91ggJmpJrN95nAnClpfYvOYtM8SZ6hKP/upCHGAk8X96P9QBIhL7
	XrxjhBgvIPFt8iEWiHJZiU0HmCE+X8Qucee2AIQtKXFwxQ2WCYwSs5AsnoVk8Swki2ch2bCA
	kWUVo2hqQXJBcVJ6rqFecWJucWleul5yfu4mRkhMSe1gXNlgcYhRgINRiYf34ZfdAUKsiWXF
	lbmHGCU4mJVEeKOs9wQI8aYkVlalFuXHF5XmpBYfYvQBOnwis5Rocj4w3vNK4g2NjU3MTExN
	zC1NzU1xCCuJ8zZ7pAQICaQnlqRmp6YWpBbBjGPi4JRqYOzt3nS69ASz4vlNF+Y+sDx0Se3Z
	FdZHJirvjj5M/L1Y/u2WQ5ZL7iQtnm3X033557QamwV+srod5XL/7hSLtjLrzN7LM+dVO/OJ
	dhP+paVXv3Kc89i/ctb9xL123iEd07337uw41DzlvqRvsFCZ1pSyFReCLP5IdXseF3TRXdhZ
	/Ozm5knZtVuVWIozEg21mIuKEwHIo7881gIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMIsWRmVeSWpSXmKPExsVy+t9jQV2unD0BBiuOa1lc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjPWvDrMXrOOoWPn6GlsD
	40u2LkYODgkBE4knrQldjJxAppjEhXvrgcJcHEIC0xklHhyZxAzhzGOSmPH7NBtIFZuAhsTh
	98/YQWwRgRCJ8y/XM4PYzALVEo+61rKA2EICpRL/fh5mBVnAKRAs8e5oCIgpLOAo8X6FGkgF
	i4CqxPWVHYwgNq+ArcSmXZ9ZIWxBiR+T77FATNSSWL/zOBOELS+xec1bZoiT1SUe/dWFOMBI
	4v/0fqgDRCT2vXjHOIFRaBaSSbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrqFSfmFpfmpesl
	5+duYgTH7DOpHYwrGywOMQpwMCrx8D78sjtAiDWxrLgy9xCjBAezkghvlPWeACHelMTKqtSi
	/Pii0pzU4kOMPkCPTmSWEk3OB6aTvJJ4Q2MTMyNLIzMLIxNzcxzCSuK8zR4pAUIC6Yklqdmp
	qQWpRTDjmDg4pRoYV27pvGyndTzb9nbCtcBL0nJfnfWNLlxoZvp2tbLMKkjyYOl/Jc9z61Y2
	z6kp7s6OkFu8OyRCUML+yva0XCf1iXHlf3nyzZTin4ez/MtNOhdkem77h9+7bk+52fbL/Ial
	brL07mDW6tKahDCJqrlp8+S1LW+kd1guj1kge//K8bz9ZeIyu18osRRnJBpqMRcVJwIAP6M2
	NgYDAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> On 27 November 2012 20:19, Axel Lin <axel.lin@ingics.com> wrote:
> > I got below build error with random config if CONFIG_PINCTRL_SAMSUNG=y
> &&
> > CONFIG_PINCTRL_EXYNOS5440=y.
> >
> > Fix the build error by making pcfgs static.
> >
> >   LD      drivers/pinctrl/built-in.o
> > drivers/pinctrl/pinctrl-exynos5440.o: In function `.LANCHOR0':
> > pinctrl-exynos5440.c:(.data+0x54): multiple definition of `pcfgs'
> > drivers/pinctrl/pinctrl-samsung.o:pinctrl-samsung.c:(.data+0x54): first
> defined here
> > make[2]: *** [drivers/pinctrl/built-in.o] Error 1
> > make[1]: *** [drivers/pinctrl] Error 2
> > make: *** [drivers] Error 2
> >
> > Signed-off-by: Axel Lin <axel.lin@ingics.com>
> 
> Acked-by: Thomas Abraham <thomas.abraham@linaro.org>
> 
> Dear Mr. Kim,
> 
> Could you please consider this patch in your next pull request for fixes.
> 
Sure, I will.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

