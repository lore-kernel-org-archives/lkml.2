Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934210Ab2JaC1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 22:27:20 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:17897 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933202Ab2JaC1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 22:27:18 -0400
X-AuditID: cbfee60c-b7fb06d00000355f-08-50908c814136
Date: Wed, 31 Oct 2012 02:27:13 +0000 (GMT)
From: =?euc-kr?B?x9S47cHW?= <myungjoo.ham@samsung.com>
Subject: Re: Re: [linux-next PATCH] PM / devfreq: documentation cleanups for
 devfreq header
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Nishanth Menon <nm@ti.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?euc-kr?Q?=C0=CC=C1=BE=C8=AD?= <jonghwa3.lee@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121031022511851@myungjoo.ham
Msgkey: 20121031022511851@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121031022511851@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29176137.554861351650430580.JavaMail.weblogic@epv6ml03>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKKsWRmVeSWpSXmKPExsVy+t8zTd3GngkBBld3mlpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MR00f2AsWcVWsmHaNpYHxD2cXIyeHkIC6xKIlJ9lAbAkBE4kL
	TTehbDGJC/fWA9lcQDXLGCX2HLvAClN0peciO0RiPqPE8knbwDpYBFQlrrw8DlTEwcEmYC5x
	f0YQSFhYIFri7Od+FhBbBKhky5P/YL3MArOZJf6efsEKcYWSxJp9r8CKeAUEJU7OfMICsUxV
	YueMi8wQcTWJszO6oI6QkJg1HeYgXokZ7U+h6uUkpn1dwwxhS0ucn7WBEeabxd8fQ8X5JY7d
	3sEEcidI75P7wTBjdm/+AvW8gMTUMwcZIUq0JDrXykGE+STWLHzLAjNl16nlzDCt97fMZQKx
	mQUUJaZ0P2SHsLUkvvzYx4buK14BF4mnZx8xTmBUnoUkNQtJ+ywk7chqFjCyrGIUTS1ILihO
	Sk810itOzC0uzUvXS87P3cQISQs8OxjnNFgcYhTgYFTi4TX41x8gxJpYVlyZe4hRgoNZSYT3
	YsaEACHelMTKqtSi/Pii0pzU4kOMPsD4m8gsJZqcD0xZeSXxhsYGxoaGloZmppamBjiElcR5
	6zxSAoQE0hNLUrNTUwtSi2DGMXFwSjUwrpM5qH1D6HLCVVcB+X9lxfs2dZTNbBMSFllWssjt
	XvP1DeoPzz2dycSc8UFiBuND9nCtiM/KKfu+XYi6ubrCVUk+bNnhVS68280j3q/eyapiW1LN
	pC2ymX87Q8K/HVwhyeVSJmeUFPxm8sgfF22JP1p3kDUz94LuEZ61Dyb61nv+4bh4wrlAiaU4
	I9FQi7moOBEAIKvvDzgDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrFKsWRmVeSWpSXmKPExsVy+t/tmbqNPRMCDG6sMrS4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GY+aPrAXLOKqWDHtGksD4x/OLkZODiEBdYlFS06ygdgSAiYSV3ouskPYYhIX7q0HinMB1cxn
	lFg+aRtYEYuAqsSVl8dZuxg5ONgEzCXuzwgCCQsLREuc/dzPAmKLAJVsefKfHaSXWWA2s8Tf
	0y9YIZYpSazZ9wqsiFdAUOLkzCcsEMtUJXbOuMgMEVeTODujixUiLiExa/oFKJtXYkb7U6h6
	OYlpX9cwQ9jSEudnbWCEOXrx98dQcX6JY7d3MIHcCdL75H4wzJjdm79A/SsgMfXMQUaIEi2J
	zrVyEGE+iTUL37LATNl1ajkzTOv9LXOZQGxmAUWJKd0P2SFsLYkvP/axofuKV8BF4unZR4wT
	GOVmIUnNQtI+C0k7spoFjCyrGEVTC5ILipPSU430ihNzi0vz0vWS83M3MYIT1DOeHYxzGiwO
	MQpwMCrx8Br86w8QYk0sK67MPcQowcGsJMJ7MWNCgBBvSmJlVWpRfnxRaU5q8SFGH2D8TWSW
	Ek3OBybPvJJ4Q2MDY0NDS3MDU0MjCxzCSuK8dR4pAUIC6YklqdmpqQWpRTDjmDg4pRoYnbcl
	aHktXpvY8zfpwv5VZm7SYuz/124QTvnJW5hbXNfUsWJGRcDm67vU5ATZlZYx+j+M+Pn5SOeF
	SL8jSnbZN/Qu6Gp8nB9jfGnjLPGn8h9La58XZ3V7it57kH44VIBZykXzg1iHo6eY78qAKOmn
	1hwVCtYeocdMtO+tZPzcav5N8sqaoANKLMUZiYZazEXFiQDN5dfJfQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9V2RPp1016039

> On Tuesday, October 30, 2012 08:09:09 AM MyungJoo Ham wrote:
[]
> > 
> > Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> > 
> > Applying to git://git.kernel.org/pub/scm/linux/kernel/git/mzx/devfreq.git for-rafael, which is based on rafael's linux-pm.git / linux-next.
> > 
> > http://git.kernel.org/?p=linux/kernel/git/mzx/devfreq.git;a=shortlog;h=refs/heads/for-rafael
> > 
> > I'll apply your "Add sysfs node ..." patch after refactoring with Jonghwa's (devfreq trans_stat) as the two patches use the same data (list of available freqs).
> 
> May I assume that you'll handle all of the subsequent devfreq patches too?
> 
> Rafael

Yes, you may. I'll apply the patches (currently at http://git.kernel.org/?p=linux/kernel/git/mzx/devfreq.git;a=shortlog;h=refs/heads/for-rafael ) and send pull requests to you or Linus.

Anyway, do you want me to keep sending pull requests to you as you've told
last time?


Cheers,
MyungJoo

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
