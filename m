Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645Ab3AJBhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 20:37:21 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:22326 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932383Ab3AJBhT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 20:37:19 -0500
X-AuditID: cbfee61b-b7f616d00000319b-82-50ee1b4d6850
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Sean Paul'" <seanpaul@chromium.org>,
        linux-arm-kernel@lists.infradead.org,
        "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>,
        linux-samsung-soc@vger.kernel.org
Cc: thomas.abraham@linaro.org
References: <1357592400-18117-1-git-send-email-seanpaul@chromium.org>
 <CAOw6vbJRoFtrhhhf4t0KDu72TieKBQ0LDvgPVfi7Q4OwQUTqDw@mail.gmail.com>
In-reply-to: <CAOw6vbJRoFtrhhhf4t0KDu72TieKBQ0LDvgPVfi7Q4OwQUTqDw@mail.gmail.com>
Subject: RE: [PATCH] ARM: dts: exynos5250: Set HDMI version to v1.4
Date: Wed, 09 Jan 2013 17:37:05 -0800
Message-id: <00e101cdeed3$00a18d30$01e4a790$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: AQG3H/7Zs9E9Kjqpy/8b1G4W67LgIAFq0v62mGQPTnA=
Content-language: en-us
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLIsWRmVeSWpSXmKPExsVy+t8zQ11f6XcBBlv2m1lc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGWcPtjDWNDGUrF5yXq2BsapzF2MnBwSAiYSy25OhrLF
	JC7cW8/WxcjFISSwjFHix9Hn7DBFa1b2MkMkFjFKXLj6DqrqL6PEphenGEGq2AQ0JA6/f8YO
	khAR2MAo8WjpSqAWDg5mAVmJYz/1QWqEBHoYJbasqgGxOQWCJW7dvcQGYgsLOEs8e7mdFcRm
	EVCVWHL5F5jNK2Ap8aZrOpQtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+hXlCQ2HH2Ndg9IgJW
	Es+WvGSEqBGXmPTgITvEfAGJb5MPsYCcJgF02qYDYI9JCKxil/j0YiIrxBxJiYMrbrBMYJSY
	hWT1LCSrZyFZPQvJigWMLKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxQuJMegfjqgaLQ4wC
	HIxKPLyMnm8DhFgTy4orcw8xSnAwK4nwhmwHCvGmJFZWpRblxxeV5qQWH2L0Abp8IrOUaHI+
	MAXklcQbGhubmJmYmphbmpqb4hBWEudlPPUkQEggPbEkNTs1tSC1CGYcEwenVAPjOvYfeuYX
	XKO/ssz60/Ju8xbh5Dt3H649P32qkMO73Asn3i7lcajec27KLcajFg/3q9tr3J03SXVySVd+
	xgY7vicfPE4Z/V/1Q7To58TjIprFuwySrx6y7H0sGxAftLfK+ek3Q/XTS1xSVD/O3WrYEVej
	+jt+WxyfVk+MT/SlxfqRvY7PWQJ9lFiKMxINtZiLihMB49n+LOACAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jAV1f6XcBBncnGltc3jWHzWLG+X1M
	DkwenzfJBTBGNTDaZKQmpqQWKaTmJeenZOal2yp5B8c7x5uaGRjqGlpamCsp5CXmptoqufgE
	6Lpl5gCNVlIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jFmnD7Yw1jQxlKx
	ecl6tgbGqcxdjJwcEgImEmtW9kLZYhIX7q1n62Lk4hASWMQoceHqOyjnL6PEphenGEGq2AQ0
	JA6/f8YOkhAR2MAo8WjpSqB2Dg5mAVmJYz/1QWqEBHoYJbasqgGxOQWCJW7dvcQGYgsLOEs8
	e7mdFcRmEVCVWHL5F5jNK2Ap8aZrOpQtKPFj8j0WEJtZQEti/c7jTBC2vMTmNW+hLlWQ2HH2
	Ndg9IgJWEs+WvGSEqBGXmPTgIfsERqFZSEbNQjJqFpJRs5C0LGBkWcUomlqQXFCclJ5rpFec
	mFtcmpeul5yfu4kRHMXPpHcwrmqwOMQowMGoxMPL6Pk2QIg1say4MvcQowQHs5IIb8h2oBBv
	SmJlVWpRfnxRaU5q8SFGH6BPJzJLiSbnAxNMXkm8obGJmZGlkZmFkYm5OQ5hJXFexlNPAoQE
	0hNLUrNTUwtSi2DGMXFwSjUwdhtd8DzNbZiW/jS8nkVA63PusZgIexfm6wpyVYJzZ9tJTe6J
	Md0beSWqM3RZYpNcjd2S4gVMu+8G/06ZaiGgevViTIzkvcWH1Z7tlb+7meHYIubnD5fefSah
	dlzO9Xh+0/fAC/dW6m//ELiu3sTIM2qvWHriRf6ekKPLqtiUZVv32D3/wtmoxFKckWioxVxU
	nAgAJChodA8DAAA=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Paul wrote:
> 
> On Mon, Jan 7, 2013 at 4:00 PM, Sean Paul <seanpaul@chromium.org> wrote:
> > Set the HDMI version to v1.4 for all exynos5250 targets. This property
> > was previously being inferred by the existence of the hdmi node.
> >
> > Signed-off-by: Sean Paul <seanpaul@chromium.org>
> > ---
> 
> The patch adding the property has churned a bit from
> devicetree-discuss reviews. I'll upload this again after it's settled.
> 
> Please drop.
> 
OK, thanks for your information.

- Kukjin

