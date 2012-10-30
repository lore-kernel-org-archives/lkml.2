Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170Ab2J3IJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 04:09:18 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:29957 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755865Ab2J3IJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 04:09:15 -0400
X-AuditID: cbfee60e-b7f8e6d0000072f3-e0-508f8b260867
Date: Tue, 30 Oct 2012 08:09:10 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Re: [linux-next PATCH] PM / devfreq: documentation cleanups for
 devfreq header
To: Randy Dunlap <rdunlap@xenotime.net>, Nishanth Menon <nm@ti.com>
Cc: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121030080317357@myungjoo.ham
Msgkey: 20121030080317357@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121030080317357@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <31002982.486491351584547433.JavaMail.weblogic@epv6ml03>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGKsWRmVeSWpSXmKPExsVy+t8zPV217v4AgxvrdS0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGn9ZmpoJ5AhU/ns5jbmB8wt/FyMkhJKAusWjJSTYQW0LAROJA
	21V2CFtM4sK99UBxLqCaZYwS73+1ssIU/Z52kgkiMZ9R4veTnSwgCRYBVYm244+BEhwcbAJ6
	EjM/J4OEhQWiJc5+7gcrERHwlJi8ppsFpJdZ4DuTxPlZn1ghrlCSWLPvFVgRr4CgxMmZT1gg
	lqlK/H10kxEiriax+c5vqCMkJGZNvwBl80rMaH8KVS8nMe3rGmYIWxpo/gZGmG8Wf38MFeeX
	OHZ7B9idIL1P7gfDjNm9+Qs0IAQkpp45CNWqJbH/0iyoVXwSaxa+ZYEZs+vUcmaY3vtb5jKB
	2MwCihJTuh+yQ9haEl9+7GND9xavgIvEmUefmCYwKs9CkpqFpH0WknZkNQsYWVYxiqYWJBcU
	J6WnmugVJ+YWl+al6yXn525ihCQGvh2M8xosDjEKcDAq8fBuWNMXIMSaWFZcmXuIUYKDWUmE
	N9+7P0CINyWxsiq1KD++qDQntfgQow8wAicyS4km5wOTVl5JvKGxgbGhoaWhmamlqQEOYSVx
	3nqPlAAhgfTEktTs1NSC1CKYcUwcnFINjC7VmjUrDwh/naD8Okz+7LXIApXsTqesvQu2fUiV
	EDzZ+5Dj0/ZD557YGV95cLzaLGPKce+9veK3eB1cG39XbY/fYc55/e8zPYeJjVUq97blrj5Y
	bvn6woFj+25mzV3iM6Vu77zgWcULyl3b7xpKLi79tak36XCuXsHEo1GpVZO2Ll+aHlBqkKHE
	UpyRaKjFXFScCACaaxtIOQMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNKsWRmVeSWpSXmKPExsVy+t/tGbpq3f0BBgtPqlpc3jWHzYHR4/Mm
	uQDGqAybjNTElNQihdS85PyUzLx0WyXv4HjneFMzA0NdQ0sLcyWFvMTcVFslF58AXbfMHKCh
	SgpliTmlQKGAxOJiJX07m6L80pJUhYz84hJbpWgjA2M9I1MTPSNjAz0Tg1grQwMDI1OgqoSM
	jD+tzUwF8wQqfjydx9zA+IS/i5GTQ0hAXWLRkpNsILaEgInE72knmSBsMYkL99YDxbmAauYz
	Svx+spMFJMEioCrRdvwxUBEHB5uAnsTMz8kgYWGBaImzn/vBSkQEPCUmr+lmAellFvjOJHF+
	1idWiGVKEmv2vQIr4hUQlDg58wkLxDJVib+PbjJCxNUkNt/5zQoRl5CYNf0ClM0rMaP9KVS9
	nMS0r2uYIWxpoPkbGGGOXvz9MVScX+LY7R1gd4L0PrkfDDNm9+YvUP8KSEw9cxCqVUti/6VZ
	UKv4JNYsfMsCM2bXqeXMML33t8wFhw+zgKLElO6H7BC2lsSXH/vY0L3FK+AicebRJ6YJjHKz
	kKRmIWmfhaQdWc0CRpZVjKKpBckFxUnpqSZ6xYm5xaV56XrJ+bmbGMEp6hnfDsZ5DRaHGAU4
	GJV4eDes6QsQYk0sK67MPcQowcGsJMKb790fIMSbklhZlVqUH19UmpNafIjRBxiBE5mlRJPz
	gekzryTe0NjA2NDQ0tzA1NDIAoewkjhvvUdKgJBAemJJanZqakFqEcw4Jg5OqQZGMa51IgKh
	p28fVl907V9k34w//5bn9zQaZqv+XHG1IuF95oL061wzDnfv9LDf6vHu04abUfZ3HwS92rHz
	XUXj1yM2y1n/T2R+8P1Z8IxDxfcEfk2O2qkgsl1fK33Pg8XMv757Ls+fHb6g7Pekxi3rdk09
	Erlvp1DI0YZU5rgTPAsb6x7Gayb32imxFGckGmoxFxUnAgCtALHJfgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9U89OGU011154

> On 10/29/2012 06:02 AM, Nishanth Menon wrote:
> 
> > struct parameters need to have ':' in documentation for
> > scripts/kernel-doc to parse appropriately.
> > 
> > Fix the errors reported by:
> > ./scripts/kernel-doc include/linux/devfreq.h >/dev/null
> > 
> > Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> > Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> > Cc: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: Kevin Hilman <khilman@ti.com>
> > Cc: linux-pm@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > 
> > Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> 
> Acked-by: Randy Dunlap <rdunlap@xenotime.net>
> 
> Thanks.

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

Applying to git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git for-rafael, which is based on rafael's linux-pm.git / linux-next.

http://git.kernel.org/?p=linux/kernel/git/mzx/devfreq.git;a=shortlog;h=refs/heads/for-rafael

I'll apply your "Add sysfs node ..." patch after refactoring with Jonghwa's (devfreq trans_stat) as the two patches use the same data (list of available freqs).

Cheers,
MyungJoo

> 
> > ---
> > Applies on
> > linux-next                e083feb Merge branch 'acpi-next' into linux-next
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git
> > 
> >  include/linux/devfreq.h |   54 +++++++++++++++++++++++------------------------
> >  1 file changed, 27 insertions(+), 27 deletions(-)
> > 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
