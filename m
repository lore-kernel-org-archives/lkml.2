Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757179Ab2KVTfw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:35:52 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:59006 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2KVTfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:35:48 -0500
X-AuditID: cbfee61b-b7f616d00000319b-94-50adcca66f28
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Doug Anderson'" <dianders@chromium.org>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: linux-samsung-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        "'Olof Johansson'" <olof@lixom.net>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Padmavathi Venna'" <padma.v@samsung.com>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Wolfram Sang'" <w.sang@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1353450428-2615-1-git-send-email-dianders@chromium.org>
 <1353450428-2615-2-git-send-email-dianders@chromium.org>
 <20121121040913.GA13280@sirena.org.uk>
 <CAD=FV=V-59u-J40G3x9oK5phUX-5pa9xJLN9QnGJCRqGfc_2ow@mail.gmail.com>
In-reply-to: <CAD=FV=V-59u-J40G3x9oK5phUX-5pa9xJLN9QnGJCRqGfc_2ow@mail.gmail.com>
Subject: RE: [PATCH 2/2] i2c: s3c2410: Get the i2c bus number from alias id
Date: Thu, 22 Nov 2012 15:56:38 +0900
Message-id: <0f5f01cdc87e$84cacc50$8e6064f0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3IFrvYD3sAbhE7QUOnPIUUOEWWiwAYQjXw
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrAIsWRmVeSWpSXmKPExsVy+t8zQ91lZ9YGGOy6rGTR8fcLo8XlXXPY
	LGac38fkwOzxeZNcAGMUl01Kak5mWWqRvl0CV8aHzydZCnZzVtyaq9XAuIe9i5GTQ0LARGLG
	joOsELaYxIV769m6GLk4hASWMUo0npkP5HCAFc2+wQ0Rn84osa13OyOE85dR4vfpZ2wg3WwC
	GhKH3z8DmyoikCjxcflEsEnMAleYJNb/eAM19j2jxPKJx8CqOAWCJZZ+eM0IYgsLeEscW7oO
	zGYRUJVY8+stWA2vgK3ElI7bTBC2oMSPyfdYQGxmAS2J9TuPM0HY8hKb17xlhjhVXeLRX12I
	I4wkvi3YBVUiIrHvxTuo8QIS3yYfYoEol5XYdIAZ4vt17BK/V0LZkhIHV9xgmcAoMQvJ4llI
	Fs9CsngWkg0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYoREm/QOxlUNFocYBTgYlXh4
	MwzWBgixJpYVV+YeYpTgYFYS4V1UABTiTUmsrEotyo8vKs1JLT7E6AN0+ERmKdHkfGAiyCuJ
	NzQ2NjEzMTUxtzQ1N8UhrCTO2+yREiAkkJ5YkpqdmlqQWgQzjomDU6qBccXBss0zLos/7+KW
	mvl3R/6PnXbbzrCIrk3PWR6yV+yQwaQJYtaXhT4oXkzhn9FgpPtrC8euuolymt0v5xhUVq/k
	EHg235lH/eFv0UV/i7sarO4/+SEn18D+2Oa2wP9Gr5LJGRm/XpsFN2nW+XulmeSc2y/zu6H2
	hcbh3We5bnWvlem/PlmwRomlOCPRUIu5qDgRAPxbfYTjAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgleLIzCtJLcpLzFFi42I5/e+xoO6yM2sDDM7PkLPo+PuF0eLyrjls
	FjPO72NyYPb4vEkugDGqgdEmIzUxJbVIITUvOT8lMy/dVsk7ON453tTMwFDX0NLCXEkhLzE3
	1VbJxSdA1y0zB2i+kkJZYk4pUCggsbhYSd8O04TQEDddC5jGCF3fkCC4HiMDNJCwjjHjw+eT
	LAW7OStuzdVqYNzD3sXIwSEhYCIx+wZ3FyMnkCkmceHeerYuRi4OIYHpjBLberczQjh/GSV+
	n37GBlLFJqAhcfj9M3YQW0QgUeLj8olgHcwCV5gk1v94A9X+nlFi+cRjYFWcAsESSz+8ZgSx
	hQW8JY4tXQdmswioSqz59RashlfAVmJKx20mCFtQ4sfkeywgNrOAlsT6nceZIGx5ic1r3jJD
	nK0u8eivLsQRRhLfFuyCKhGR2PfiHeMERqFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRHM3PpHcwrmqwOMQowMGoxMObYbA2QIg1say4MvcQowQHs5II76IC
	oBBvSmJlVWpRfnxRaU5q8SFGH6BHJzJLiSbnAxNNXkm8obGJmZGlkZmFkYm5OQ5hJXHeZo+U
	ACGB9MSS1OzU1ILUIphxTBycUg2MSlxzF0qK2guWn78a/eov90vTfLVZofpzMyqSN73rWp/4
	8byduLyGmWes35LDe2p4/VZ9PVZy4YL0XMYDV49IL5umXCQWrPqi5Y8Bt8WNTxX/U9kkM/5W
	lrZMeJtaLys+SWS5TEzm7jtbaz+fXSvy2WpZsvzG9KfR1yo2b5k5/ZjsM/OFzPtWKLEUZyQa
	ajEXFScCAM6juuQTAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doug Anderson wrote:
> 
> On Tue, Nov 20, 2012 at 8:09 PM, Mark Brown
> <broonie@opensource.wolfsonmicro.com> wrote:
> > On Tue, Nov 20, 2012 at 02:27:04PM -0800, Doug Anderson wrote:
> >> From: Padmavathi Venna <padma.v@samsung.com>
> >>
> >> Get the i2c bus number that the device is connected to using the alias
> >> id.  This makes debugging / grokking of kernel messages much easier.
> >
> > This doesn't look like a s3c2410 specific change - it's a generic device
> > tree issue.  This suggests that it sohuld be implemented in the
> > framework so that all I2C controllers with DT can use it.
> 
> Good suggestion.  I have posted a series with the title "Add automatic
> bus number support for i2c busses with device tree".  It contains the
> i2c-core patch as well as a patch removing similar code from the pxa
> i2c driver.
> 
> Kukjin: please consider this patch abandoned and superseded by the new
> i2c-core patch.  As Olof said, the patch for adding aliases for
> exynos4 should still be fine to apply.
> 
OK, I see.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

