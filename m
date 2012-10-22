Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932766Ab2JVBCK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 21:02:10 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:56481 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab2JVBCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 21:02:05 -0400
X-AuditID: cbfee61b-b7f616d00000319b-36-50849b0b2263
From: Jingoo Han <jg1.han@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Ryan Mallon'" <rmallon@gmail.com>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <002801cdac0a$11e4f340$35aed9c0$%han@samsung.com>
 <CACRpkdYx1HLF2==6DsPp+qC6Xyb7Ag8qa1K7g2Ht-Y2T-UjzMA@mail.gmail.com>
In-reply-to: <CACRpkdYx1HLF2==6DsPp+qC6Xyb7Ag8qa1K7g2Ht-Y2T-UjzMA@mail.gmail.com>
Subject: Re: [PATCH V3] gpio: samsung: use pr_* instead of printk
Date: Mon, 22 Oct 2012 10:02:03 +0900
Message-id: <00a201cdaff0$d90a11a0$8b1e34e0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2t4cSGBZ8/e71VS3SeimKz082RiACDptxQ
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jQV3u2S0BBvP3CFpc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGU0PdnMVnCMtWL+mtksDYybWboYOTkkBEwkrlyeyghh
	i0lcuLeerYuRi0NIYDqjRFvfNijnF6NE+7LbYFVsAmoSX74cZgexRQT0JN58bWEHKWIWeMQo
	sfH5YSaQhJBAC6PE5h/BIDanQLDEjsMXWEFsYQFHiZU9i8GaWQRUJebt/AcW5xWwlfjbOI0Z
	whaU+DH5Hth5zAJaEpu3NbFC2PISm9e8BarhADpVXeLRX12IG4wkpuy9wQhRIiKx78U7xgmM
	QrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4qJ9J72Bc1WBx
	iFGAg1GJh9diRkuAEGtiWXFl7iFGCQ5mJRHeU/FAId6UxMqq1KL8+KLSnNTiQ4zSHCxK4rzN
	HikBQgLpiSWp2ampBalFMFkmDk6pBkbTE9c0jwick3f+Pc30Vce7Y9eFE9RnRzH+fn9D8HTc
	zJgwuYrYu3v3WwXe5Vo6ve/Kmc36YTwi/TeqZU3dlyQEHrLjMDq9l/cJn9iXHJfbUxO5vlpE
	M18WNd+7b89Z8bp3vxyKioOO1G69PmfR3jCm44G3D99x3j8t/nnw1xeNmlm/eg/ICTEpsRRn
	JBpqMRcVJwIAaGl3lGYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 19, 2012 7:09 PM Linus Walleij wrote
> 
> On Wed, Oct 17, 2012 at 3:52 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> 
> > This patch uses pr_* instead of printk. Also, gpio_dbg
> > is replaced with pr_debug.
> >
> > Signed-off-by: Jingoo Han <jg1.han@samsung.com>
> > Reviewed-by: Linus Walleij <linus.walleij@linaro.org> <- NAK
> 
> Please consult Documentation/SubmittingPatches as to the conditions that
> apply when you add Reviewed-by tags.

Um, you already gave the Reviewed-by to the same patch, a month ago.
Anyway, I will remove Reviewed-by and send v4 patch, soon.

> 
> Hint: it doesn't mean "I know Linus looked at this patch".
> 
> Yours,
> Linus Walleij

