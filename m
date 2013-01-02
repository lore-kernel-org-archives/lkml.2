Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab3ABW1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 17:27:25 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:53224 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3ABW1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 17:27:22 -0500
X-AuditID: cbfee61b-b7f616d00000319b-89-50e4b4490c57
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Olof Johansson'" <olof@lixom.net>, "'Dongjin Kim'" <tobetter@gmail.com>
Cc: "'Russell King'" <linux@arm.linux.org.uk>,
        "'Jason Cooper'" <jason@lakedaemon.net>,
        "'Shawn Guo'" <shawn.guo@linaro.org>, "'Andrew Lunn'" <andrew@lunn.ch>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1356921314-12595-1-git-send-email-tobetter@gmail.com>
 <1356921314-12595-2-git-send-email-tobetter@gmail.com>
 <CAOesGMgoyT2xTwgPBw1CASO-6iakpRLxEh1aad-LL7SxJ1+5Vg@mail.gmail.com>
In-reply-to: <CAOesGMgoyT2xTwgPBw1CASO-6iakpRLxEh1aad-LL7SxJ1+5Vg@mail.gmail.com>
Subject: RE: [PATCH v3 1/4] ODROID-X: dts: Add board dts file for ODROID-X
Date: Wed, 02 Jan 2013 14:27:07 -0800
Message-id: <042501cde938$4e37c2d0$eaa74870$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQMdp7Oy/x7NQaebv25b7lhhe1DB/QGi/i6SAXE5FquVfn8VQA==
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJIsWRmVeSWpSXmKPExsVy+t8zY13PLU8CDD485be4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZp9rPsxecYql4sH0XYwPjIeYuRk4OCQETidV9p6FsMYkL99az
	dTFycQgJLGOUWPxvEVzRgc+rmUBsIYFFjBIbZ9tDFM1jkjjUM5MFJMEmoCFx+P0zdhBbRMBT
	Yt/8+YwgRcwCfUwS56e9Y4foOMQoseYexChOgWCJRRtfgK0QFvCSOP/8ISOIzSKgKnHpZgfY
	VF4BS4mLj7+xQ9iCEj8m3wOLMwtoSazfeZwJwpaX2LzmLdSpChI7zr5mhLjCSeLxorOsEDXi
	EpMePGSHmC8g8W3yIaA5HED1shKbDjCD3CYhMI9dYtnJ51BzJCUOrrjBMoFRYhaS1bOQrJ6F
	ZPUsJCsWMLKsYhRNLUguKE5KzzXSK07MLS7NS9dLzs/dxAiJL+kdjKsaLA4xCnAwKvHwMtY/
	CRBiTSwrrswFhg4Hs5II7/UcoBBvSmJlVWpRfnxRaU5q8SFGH6DLJzJLiSbnA2M/ryTe0NjY
	xMzE1MTc0tTcFIewkjhvs0dKgJBAemJJanZqakFqEcw4Jg5OqQbGsNuc0SLPVWZ4J4mrdqX+
	utN8iV/IpcmnU+BKgmWLqeaNwJ4djterblrXPAsRWPZn8YybEfNu6V0P2VT6S2DqoS4uhvbc
	+bs/JHuq1k/75S+qcKfycMOhaObdPx4nGr34L37Bt/d+q/2HHTqqopx8LxhDbnU3nHtz6rRA
	8kKXU4H3T2brSt9XYinOSDTUYi4qTgQAIN9qcNwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBIsWRmVeSWpSXmKPExsVy+t9jAV3PLU8CDFb2cFtc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjFPt59kLTrFUPNi+i7GB
	8RBzFyMnh4SAicSBz6uZIGwxiQv31rOB2EICixglNs6272LkArLnMUkc6pnJApJgE9CQOPz+
	GTuILSLgKbFv/nxGkCJmgT4mifPT3rFDdBxilFhzD2Isp0CwxKKNL8DWCQt4SZx//pARxGYR
	UJW4dLMDbCqvgKXExcff2CFsQYkfk++BxZkFtCTW7zzOBGHLS2xe8xbqbAWJHWdfM0Jc4STx
	eNFZVogacYlJDx6yT2AUmoVk1Cwko2YhGTULScsCRpZVjKKpBckFxUnpuUZ6xYm5xaV56XrJ
	+bmbGMHR+0x6B+OqBotDjAIcjEo8vIz1TwKEWBPLiitzgb7lYFYS4b2eAxTiTUmsrEotyo8v
	Ks1JLT7E6AP06URmKdHkfGBiySuJNzQ2MTOyNDKzMDIxN8chrCTO2+yREiAkkJ5YkpqdmlqQ
	WgQzjomDU6qB0WNaX+jDnZfmXDC6ZL1LXVlx4b4z7OzZLGnMdkxmi3v+Tgi538O9S+Bbz+5z
	33k/13Ay7uiy+5/9f71Ma9LO9XEuH3I65rL1F2jMfpEQ8JQ756YoV8Ev470Pt4swMP86XzHX
	e9+7vEL5hpCpjcVl1uz7DgQpmoccUneWS+9TWfLkn/OdZXn5SizFGYmGWsxFxYkA3N4UjwsD	AAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Olof Johansson wrote:
> 
> On Sun, Dec 30, 2012 at 6:35 PM, Dongjin Kim <tobetter@gmail.com> wrote:
> > Add initial dtb file for Hardkernel's ODROID-X board based on EXYNOS4412
> SoC.
> >
> > Signed-off-by: Dongjin Kim <tobetter@gmail.com>
> 
> Patch 1-4:
> 
> Acked-by: Olof Johansson <olof@lixom.net>
> 
> ... but I think it might make sense to just add the file as one commit
> instead of splitting it across 4 as this series does.
> 
I think so.

If Dongjin doesn't mind, let me squash them into on commit when I apply into
Samsung tree.

Thanks.

- Kukjin

