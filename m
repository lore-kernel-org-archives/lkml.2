Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932669Ab3AJBm7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:42:59 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:23390 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3AJBm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:42:57 -0500
X-AuditID: cbfee61b-b7f616d00000319b-f2-50ee1ca00189
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Tushar Behera'" <tushar.behera@linaro.org>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        patches@linaro.org
References: <1357287829-21701-1-git-send-email-tushar.behera@linaro.org>
 <CAJuYYwQx0hFQmkLaggd2NdA_xommXGPBDbhj1AuSH5YuASWA-w@mail.gmail.com>
In-reply-to: <CAJuYYwQx0hFQmkLaggd2NdA_xommXGPBDbhj1AuSH5YuASWA-w@mail.gmail.com>
Subject: RE: [PATCH] ARM: DTS: exynos4210-origen: Add MAX8997 node entry
Date: Wed, 09 Jan 2013 17:42:43 -0800
Message-id: <00e401cdeed3$ca5942d0$5f0bc870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQFPH86yQ3Zg+4nIJHy/f5W4MGSXLgGZVKIHmTKdI9A=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrHIsWRmVeSWpSXmKPExsVy+t8zI90FMu8CDN6vEbO4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mpo6n/KVHCFpeLS/VXMDYz3mLsYOTkkBEwk9kzeyQZh
	i0lcuLceyObiEBJYxijR0HedBaZo15q1zBCJ6YwSRydvZIFw/jJKtB/5ADaKTUBD4vD7Z+wg
	tohAnERD5zmwDmaQjnVLrjFCdPQzSjRv2gTWwSkQLPHt7H+wDmEBD4nvf86BxVkEVCV6t3wG
	WsHBwStgKbF2khRImFdAUOLH5HtgJzELaEms33mcCcKWl9i85i3UPwoSO86+ZoQ4wkpi1pct
	rBA14hKTHjxkhxgvIPFt8iGw8RICshKbDoDdKSGwil3ievNrVog5khIHV9xgmcAoMQvJ6llI
	Vs9CsnoWkhULGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoREmvQOxlUNFocYBTgYlXh4
	GT3fBgixJpYVV+YeYpTgYFYS4Q3ZDhTiTUmsrEotyo8vKs1JLT7E6AN0+URmKdHkfGASyCuJ
	NzQ2NjEzMTUxtzQ1N8UhrCTOy3jqSYCQQHpiSWp2ampBahHMOCYOTqkGRj/rU/o//bznacQ/
	k98oOatguUSWqKJqxeQJj+vr2AW+vpFkdxI/PPPb7PAYU981LcXLIreqF54RvmT8TVioWPaz
	W8ada4uetkm+/nlj1n53x63rIi5qrNlxoW56r8rmxHjrp6cZjKY/6f5i2coyx15nx5G4CbN+
	T7yXL7PDbP7H7B/Mna2sPkosxRmJhlrMRcWJANOXvS3hAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLIsWRmVeSWpSXmKPExsVy+t9jQd0FMu8CDK52CVtc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmNPU/ZSq4wlJx
	6f4q5gbGe8xdjJwcEgImErvWrIWyxSQu3FvP1sXIxSEkMJ1R4ujkjSwQzl9GifYjH8Cq2AQ0
	JA6/f8YOYosIxEk0dJ5jBiliBulYt+QaI0RHP6NE86ZNYB2cAsES387+B+sQFvCQ+P7nHFic
	RUBVonfLZ6AVHBy8ApYSaydJgYR5BQQlfky+xwJiMwtoSazfeZwJwpaX2LzmLdSpChI7zr5m
	hDjCSmLWly2sEDXiEpMePGSfwCg0C8moWUhGzUIyahaSlgWMLKsYRVMLkguKk9JzjfSKE3OL
	S/PS9ZLzczcxguP4mfQOxlUNFocYBTgYlXh4GT3fBgixJpYVV+YeYpTgYFYS4Q3ZDhTiTUms
	rEotyo8vKs1JLT7E6AP06ERmKdHkfGCKySuJNzQ2MTOyNDKzMDIxN8chrCTOy3jqSYCQQHpi
	SWp2ampBahHMOCYOTqkGxkWefktuVvo5d56s3GMe02f5MOXy2pWJurOdbF/U72vbWizLXXTk
	jkHD/hTxQ/3njjSfSZqp1WBQsnSm97PJN5fMO7Lk483I40f4DDysqtI372n59GFpfdbUg48+
	dmztPzBt7t+Ptv6XDqz3O56sv7Xp26rre9OvrVlrvMZESzDl3uGmWWEuDl1KLMUZiYZazEXF
	iQB5gPt4EAMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Abraham wrote:
> 
> On 4 January 2013 00:23, Tushar Behera <tushar.behera@linaro.org> wrote:
> > The node entry is added as per documentation and legacy board file.
> >
> > Signed-off-by: Tushar Behera <tushar.behera@linaro.org>
> > ---
> > The patch is rebased on v3.8-rc1.
> >
> >  arch/arm/boot/dts/exynos4210-origen.dts |  150
> +++++++++++++++++++++++++++++++
> >  1 files changed, 150 insertions(+), 0 deletions(-)
> 
> This patch has already been posted. Here is the link:
> https://patchwork.kernel.org/patch/1794501/
> 
OK, I will apply.

Thanks.

- Kukjin

