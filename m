Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387Ab2JZGQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:16:41 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20938 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753559Ab2JZGQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:16:40 -0400
X-AuditID: cbfee611-b7fa86d0000010a9-23-508a2ac6f0fd
Date: Fri, 26 Oct 2012 06:16:38 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [for-next PATCH V2] PM / devfreq: Add sysfs node to expose
 available frequencies
To: Nishanth Menon <nm@ti.com>, linux-pm <linux-pm@vger.kernel.org>
Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Kevin Hilman <khilman@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20121026060222009@myungjoo.ham
Msgkey: 20121026060222009@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20121026060222009@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <16123783.160701351232196244.JavaMail.weblogic@epv6ml08>
DLP-Filter: Pass
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrCKsWRmVeSWpSXmKPExsVy+t8zbd1jWl0BBofm21hc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6Mq0cnMxVc4KxoXbiavYFxDWcXIyeHkIC6xKIlJ9lAbAkBE4kN
	C16wQthiEhfurQeKcwHVLGOUWP79MZDDAVb0f1s+RHw+o8T/Q+uYQOIsAqoSkz5lgZhsAnoS
	Mz8ng4wRFoiVeDH/LBOILSLgKfHn1GZGkFZmgX+MEm+3fGCGuEFJYs2+VywgNq+AoMTJmU9Y
	IG5QlfjZ18gIEVeTaD05C+o2CYlZ0y9A2bwSM9qfQtXLSUz7uoYZwpaWOD9rAyPML4u/P4aK
	80scu72DCeIVXokn94Nhxuze/AUaDAISU88chGrVklg2YyqUzSexZuFbFpgxu04tZ4bpvb9l
	LtiPzAKKElO6H7JD2FoSX37sY0P3Fq+Ai8SOmdtYJzAqz0KSmoWkfRaSdmQ1CxhZVjGKphYk
	FxQnpaea6xUn5haX5qXrJefnbmKEJAXBHYxLGywOMQpwMCrx8D6Y0BkgxJpYVlyZe4hRgoNZ
	SYR391SgEG9KYmVValF+fFFpTmrxIUYfYPxNZJYSTc4HJqy8knhDYwNjQ0NLQzNTS1MDHMJK
	4rzlHikBQgLpiSWp2ampBalFMOOYODilGhgXTA/lZPA9/PCLTJeE3pco+4XnZggKHH7NcMmW
	dd5O8S1HQ7WsCu1mdohHPaprmxPV/Vs7sjnm0uMbDgp/a3I6GrmOP2AqOtFUfFzw49LCn2Lf
	br9gMbPXzsjT15+tNy3ge9GZo++9ZlorvM1OTN/SWbzM7cmsPen8kg9z6ssN/5txfdvryqrE
	UpyRaKjFXFScCAAvM3uDNwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJKsWRmVeSWpSXmKPExsVy+t/t6brHtLoCDGY+tLC4vGsOmwOjx+dN
	cgGMURk2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4Bum6ZOUBD
	lRTKEnNKgUIBicXFSvp2NkX5pSWpChn5xSW2StFGBsZ6RqYmekbGBnomBrFWhgYGRqZAVQkZ
	GVePTmYquMBZ0bpwNXsD4xrOLkZODiEBdYlFS06ydTFycEgImEj835YPEpYQEJO4cG89UJgL
	qGQ+o8T/Q+uYQGpYBFQlJn3KAjHZBPQkZn5OBikXFoiVeDH/LBOILSLgKfHn1GZGkFZmgX+M
	Em+3fGCGWKUksWbfKxYQm1dAUOLkzCcsELtUJX72NTJCxNUkWk/OYoWIS0jMmn4ByuaVmNH+
	FKpeTmLa1zXMELa0xPlZGxhhbl78/TFUnF/i2O0dTBBv8Uo8uR8MM2b35i9sELaAxNQzB6Fa
	tSSWzZgKZfNJrFn4lgVmzK5Ty5lheu9vmQv2I7OAosSU7ofsELaWxJcf+9jQvcUr4CKxY+Y2
	1gmMcrOQpGYhaZ+FpB1ZzQJGllWMoqkFyQXFSemp5nrFibnFpXnpesn5uZsYwenpmeAOxqUN
	FocYBTgYlXh4H0zoDBBiTSwrrsw9xCjBwawkwrt7KlCINyWxsiq1KD++qDQntfgQow8w/iYy
	S4km5wNTZ15JvKGxgbGhoaW5gamhkQUOYSVx3nKPlAAhgfTEktTs1NSC1CKYcUwcnFINjA0p
	n++812478PeWBFt65v3qlnu6EQ47G+Xv2R69mV7kl9QR5BR575rbfJ7jm8pDog3+c+7kemdl
	eN9Uf+7bPTwPpl+4W7TolcyyGTaxGXfKsj+0v96cttsw4Zr9XWu9Z3abmrwdN2UzNi7+UP7j
	rNerhXYd16+9+CNjH+Jx4Ki9US/jP6cZO5VYijMSDbWYi4oTAQWSD218AwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q9Q6GhqA023093

> devfreq governors such as ondemand are controlled by a min and
> max frequency, while governors like userspace governor allow us
> to set a specific frequency.
> However, for the same specific device, depending on the SoC, the
> available frequencies can vary.
> 
> So expose the available frequencies as a snapshot over sysfs to
> allow informed decisions.
> 
> This was inspired by cpufreq framework's equivalent for similar
> usage sysfs node: scaling_available_frequencies.
> 
> Cc: Rajagopal Venkat <rajagopal.venkat@linaro.org>
> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: linux-pm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
> Signed-off-by: Nishanth Menon <nm@ti.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
