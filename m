Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933069Ab2JWOKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:10:19 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:26436 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab2JWOKQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:10:16 -0400
X-AuditID: cbfee61a-b7fa66d0000004cf-95-5086a54664ab
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>,
        "'Jingoo Han'" <jg1.han@samsung.com>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ryan Mallon'" <rmallon@gmail.com>
References: <002801cdac0a$11e4f340$35aed9c0$%han@samsung.com>
 <CACRpkdYx1HLF2==6DsPp+qC6Xyb7Ag8qa1K7g2Ht-Y2T-UjzMA@mail.gmail.com>
 <00a201cdaff0$d90a11a0$8b1e34e0$%han@samsung.com>
 <CACRpkdZCH_bxviyz5Qqx0ttFFGW-CkJT6vCT3-JcOgQ5quK0kg@mail.gmail.com>
In-reply-to: <CACRpkdZCH_bxviyz5Qqx0ttFFGW-CkJT6vCT3-JcOgQ5quK0kg@mail.gmail.com>
Subject: RE: [PATCH V3] gpio: samsung: use pr_* instead of printk
Date: Tue, 23 Oct 2012 23:10:14 +0900
Message-id: <021101cdb128$1f56c1c0$5e044540$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2wot87GWuNC078SY68Cimbo+Z+PgAhRwSg
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDIsWRmVeSWpSXmKPExsVy+t8zI123pW0BBtPPGVpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXM/ruUpeADR8XC439YGxib2LsYOTgkBEwk1h4P6WLk
	BDLFJC7cW8/WxcjFISSwjFFi1fr7bBAJE4lHfxqZQWwhgUWMEocWBkEU/WWUaP25lgkkwSag
	IXH4/TN2EFtEIETi2fMZrCBFzALTGCVuP5nADNHxn1Fi44xljCBVnALBEkte3QfrFhZwlPi6
	phNsHYuAqsTlX1fBbF4BW4nDW0EmgdiCEj8m32MBsZkFtCTW7zzOBGHLS2xe85YZ4h11iUd/
	dSGOMJJoe93AClEiIrHvxTtGiPECEt8mH2KBKJeV2HQA7DQJgVXsEnNetTFBfCwpcXDFDZYJ
	jBKzkGyehWTzLCSbZyFZsYCRZRWjaGpBckFxUnquoV5xYm5xaV66XnJ+7iZGSJRJ7WBc2WBx
	iFGAg1GJh9fiSGuAEGtiWXFl7iFGCQ5mJRFeU/u2ACHelMTKqtSi/Pii0pzU4kOMPkCXT2SW
	Ek3OByaAvJJ4Q2NjEzMTUxNzS1NzUxzCSuK8zR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYZ12X
	/nX6mJbL96fNFUu2WvMJ7FJ+3pqz4IQSpxrrHg2GvdfZjXgsDW3Kbs61UHXdOf/jlKs/wnLX
	Ldi6Rbgj4dT5AxZ/H1ywO7cpKGGmc012HffiR/363/fb/T1rrLCuREFlW1a7w1+Rb2HKzNkS
	Is8SdrGvt2NePTN/P+vauLmblXhWuq9/p8RSnJFoqMVcVJwIAD+IWjDfAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV23pW0BBice6Flc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmzP67lKXgA0fF
	wuN/WBsYm9i7GDk5JARMJB79aWSGsMUkLtxbzwZiCwksYpQ4tDCoi5ELyP7LKNH6cy0TSIJN
	QEPi8PtnYM0iAiESz57PYAUpYhaYxihx+8kEZoiO/4wSG2csYwSp4hQIlljy6j5Yt7CAo8TX
	NZ1gK1gEVCUu/7oKZvMK2Eoc3goyCcQWlPgx+R4LiM0soCWxfudxJghbXmLzmrdACziATlWX
	ePRXF+III4m21w2sECUiEvtevGOcwCg0C8mkWUgmzUIyaRaSlgWMLKsYRVMLkguKk9JzDfWK
	E3OLS/PS9ZLzczcxgqP4mdQOxpUNFocYBTgYlXh4LY60BgixJpYVV+YeYpTgYFYS4TW1bwsQ
	4k1JrKxKLcqPLyrNSS0+xOgD9OhEZinR5HxggskriTc0NjEzsjQyszAyMTfHIawkztvskRIg
	JJCeWJKanZpakFoEM46Jg1OqgfHIycu8583fn35d4Lw6O2SG5Sbu42cefOvoe6y0m7s0QTl1
	PV/eNgeFewFHJjYcOKhTptaXqvKxTj+Qcb5OPtexjg3vnkuV20o6Zrxo8HBYs/mASsi60wLq
	3u6qB33WXbm16bSET/zU/7ZfHsj6Nwk/ESluiC7W4izw/PxtdmP/2RUBxkFMM5RYijMSDbWY
	i4oTAR4H+wcPAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> 
> On Mon, Oct 22, 2012 at 3:02 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> > On Friday, October 19, 2012 7:09 PM Linus Walleij wrote
> >>
> >> On Wed, Oct 17, 2012 at 3:52 AM, Jingoo Han <jg1.han@samsung.com>
wrote:
> >>
> >> > This patch uses pr_* instead of printk. Also, gpio_dbg
> >> > is replaced with pr_debug.
> >> >
> >> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> >> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org> <- NAK
> >>
> >> Please consult Documentation/SubmittingPatches as to the conditions
> that
> >> apply when you add Reviewed-by tags.
> >
> > Um, you already gave the Reviewed-by to the same patch, a month ago.
> > Anyway, I will remove Reviewed-by and send v4 patch, soon.
> 
> My bad. I confused this mail thread for something else, sorry
> for this. :-(
> 
> Please keep the Reviewed-tag if you want to!
> 
Linus, if you don't have any objection, let me take this into Samsung tree.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

