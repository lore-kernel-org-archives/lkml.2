Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab2K3Kzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 05:55:39 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:52137 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755268Ab2K3Kzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 05:55:33 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-c0-50b890a2713c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Rahul Sharma'" <r.sh.open@gmail.com>,
        "'Cho KyongHo'" <pullip.cho@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        prathyush.k@samsung.com, sw0312.kim@samsung.com,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        rahul.sharma@samsung.com
References: <002101cdc8a4$fc375990$f4a60cb0$%cho@samsung.com>
 <112e01cdc951$976699b0$c633cd10$%kim@samsung.com>
 <008601cdce20$1ccffb00$566ff100$%cho@samsung.com>
 <CAPdUM4M77LGQn+FcxmsA38H9wrJX6to_OgmtkSgUYkXVuD-m2w@mail.gmail.com>
In-reply-to: <CAPdUM4M77LGQn+FcxmsA38H9wrJX6to_OgmtkSgUYkXVuD-m2w@mail.gmail.com>
Subject: RE: [PATCH v4 00/12] iommu/exynos: Fixes and Enhancements of System
 MMU driver with DT
Date: Fri, 30 Nov 2012 19:55:30 +0900
Message-id: <1d6601cdcee9$36ebd760$a4c38620$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac3OI7Kl9LKeMiuiRVWzfGEhgLgP+QAxTrpQ
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zY93FE3YEGKyRt7i8aw6bxYzz+5gc
	mDw+b5ILYIzisklJzcksSy3St0vgyli4ZSpLwUz+io+P5jI3MK7g7mLk4JAQMJE4t9yqi5ET
	yBSTuHBvPVsXIxeHkMAyRon+E43MEAkTiZv3djBDJKYzSjz+9Riq6i+jxPGfs8Gq2AQ0JA6/
	f8YOYosIBEicXNXIDlLELLCTSWLrs82MEB1vGCV+HGkHq+IUCJbYcvsOE4gtLJAo8eznflaQ
	m1gEVCXW32UBCfMK2EocXNXKDGELSvyYfA8sziygJbF+53EmCFteYvOat8wQ76hLPPqrC3GD
	kcSzu71QJSIS+168YwSxWQQEJL5NPsQCUS4rsekA2GMSAuvYJU5t2sEK8bGkxMEVN1gmMErM
	QrJ5FpLNs5BsnoVkxQJGllWMoqkFyQXFSem5hnrFibnFpXnpesn5uZsYITEmtYNxZYPFIUYB
	DkYlHt4NG7YHCLEmlhVX5h5ilOBgVhLh3Se4I0CINyWxsiq1KD++qDQntfgQow/Q5ROZpUST
	84Hxn1cSb2hsbGJmYmpibmlqbopDWEmct9kjJUBIID2xJDU7NbUgtQhmHBMHp1QDo2DQTL8N
	hQKbnUq+3sz73/WqcRdnsDijjRTDbang6Gmq//g5Fyl8KF9usEcudevHbbG8SX4ZryRfTXio
	a57buV2Tm61LO+g9u1zpvrrdgT+mr3iqvvPd6V1/pc6G1y2YvHPu5EPTZX673b39Xjfuibvt
	j74FEzWeOZ5+tS5jh0C1la6c9Yz505VYijMSDbWYi4oTAfYwIPzeAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDIsWRmVeSWpSXmKPExsVy+t9jQd1FE3YEGGz/ZG5xedccNosZ5/cx
	OTB5fN4kF8AY1cBok5GamJJapJCal5yfkpmXbqvkHRzvHG9qZmCoa2hpYa6kkJeYm2qr5OIT
	oOuWmQM0WkmhLDGnFCgUkFhcrKRvh2lCaIibrgVMY4Sub0gQXI+RARpIWMeYsXDLVJaCmfwV
	Hx/NZW5gXMHdxcjJISFgInHz3g5mCFtM4sK99WxdjFwcQgLTGSUe/3oM5fxllDj+czZYFZuA
	hsTh98/YQWwRgQCJk6sa2UGKmAV2MklsfbaZEaLjDaPEjyPtYFWcAsESW27fYQKxhQUSJZ79
	3M/axcjBwSKgKrH+LgtImFfAVuLgqlZmCFtQ4sfke2BxZgEtifU7jzNB2PISm9e8ZQZplRBQ
	l3j0VxfiBiOJZ3d7oUpEJPa9eMc4gVFoFpJJs5BMmoVk0iwkLQsYWVYxiqYWJBcUJ6XnGuoV
	J+YWl+al6yXn525iBEfxM6kdjCsbLA4xCnAwKvHwbtiwPUCINbGsuDL3EKMEB7OSCO8+wR0B
	QrwpiZVVqUX58UWlOanFhxh9gP6cyCwlmpwPTDB5JfGGxiZmRpZGZhZGJubmOISVxHmbPVIC
	hATSE0tSs1NTC1KLYMYxcXBKNTCy3eaSb/JfK7aV3et99cTuC/q8d7uuP//hYV+7bsm2OW8e
	2qo+P5hyaGnGl9BvZ7Z7f1qu5sjxtvC82sUovxlHVu+a/4fLZublpfIVi4uKi9/v3rp61u4t
	jwUUJszNf5KtrlfI+rflBF/2klt+6wtuvnA+rZa3wUL6xYtPWh9E+T+tZngW+PWOqhJLcUai
	oRZzUXEiAPnKPkEPAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rahul Sharma wrote:
>
> Hi Mr. Cho,
> 
> We have verified the above patchset for following usecases on exynos5.
> 
> 1) MFC decoding using Sysmmu_L and R. (with the bit Inversion fix)
> 2) GSC operations.
> 3) FIMD and MIXER (HDMI) as displays.
> 
> Thanks for your effort.
> 
Thanks for your test on board.

[...]

> >> > >
> >> > > Looks good to me 1st~3rd patches. After quick review, I think, 1st
> and 2nd
> >> > > patches can go to upstream for v3.8 without any dependency. So I
> will.
> >> > >
> >> > > The 3rd patch has a dependency with other driver changes (4th ~
> 12th), so it
> >> > > should be sent to upstream with others.
> >> > >
> >> > > BTW since the 3rd patch touches many Samsung stuff in arch/arm/ so
> I'd
> >> > > prefer to take it in Samsung tree. If Joerg is ok on iommu/exynos
> driver
> >> > > changes for v3.8...
> >> > >
> >> > > Joerg, please let me know about iommu/exynos stuff so that I can
> decide to
> >> > > take 3rd patch or not for v3.8.
> >> > >
> >> >
> >> > Hi, Kukjin Kim.
> >> >
> >> > I found that control bit fields of clock gating of System MMU of MFC
> L/R is inversed.
> >> > That is reported by Prathyush Kalashwaram.
> >> >
> >> > I will post v5 patchset that solves this.
> >> >
> >>
> >> I did not posted v5 patchset.
> >> Instead, I posted just the fix for the 03/12 patch mentioned above
> >> as the reply to the 03/12 patch.
> >>
> >
> > Hi, Joerg.
> >
> > I am waiting for your comment about the patchset.

Same here.

> > The latest version is v4.
> > And a fix of [patch v4 03/12] mentioned above is posted as a reply.
> >
> > If you have any concern about the patches, please let me know
> >

If there is no reply, as I said, I will apply 1st and 2nd patches...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

