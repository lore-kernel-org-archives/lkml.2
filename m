Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2LZEEH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 23:04:07 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:58498 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2LZEEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 23:04:05 -0500
X-AuditID: cbfee61b-b7f616d00000319b-db-50da77322bb1
From: Jingoo Han <jg1.han@samsung.com>
To: "'Kukjin Kim'" <kgene.kim@samsung.com>, "'Tejun Heo'" <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <1356141435-17340-24-git-send-email-tj@kernel.org>
 <00af01cddff1$4170db40$c45291c0$@samsung.com>
In-reply-to: <00af01cddff1$4170db40$c45291c0$@samsung.com>
Subject: Re: [PATCH 23/25] video/exynos: don't use [delayed_]work_pending()
Date: Wed, 26 Dec 2012 13:04:02 +0900
Message-id: <02f901cde31e$0a284df0$1e78e9d0$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AQJ/4CUv+xedZ2SKZIakOfxpmulFtgJKzeF9lq3J7KCABlmtMA==
Content-language: ko
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOIsWRmVeSWpSXmKPExsVy+t8zQ12j8lsBBhveylpc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6McyfbWAo2C1RMuruEqYGxnbeLkZNDQsBEomn1JSYIW0ziwr31
	bF2MXBxCAssYJSZevMAEUzRr/lIWiMQiRolbU+cxQTizmSRuN+9nBKliE1CT+PLlMDuILSKQ
	KvF3ciNzFyMHB7NAgsS11x5wzXcWrGcBqeEUsJJ4cPYw2AZhAW+JNc8PsYLYLAKqEhsXnAab
	wytgK9G99QcrhC0o8WPyPbBeZgEtifU7jzNB2PISm9e8BdslIaAu8eivLsQJThKH1u9mhigR
	kdj34h0jxHgBiW+TD7FAlMtKbDrADHKahMAidond329BPSwpcXDFDZYJjBKzkGyehWTzLCSb
	ZyFZsYCRZRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGSGxJ72Bc1WBxiFGAg1GJh5fz180A
	IdbEsuLK3EOMEhzMSiK8zh+BQrwpiZVVqUX58UWlOanFhxh9gC6fyCwlmpwPjPu8knhDY2MT
	MxNTE3NLU3NTHMJK4rzNHikBQgLpiSWp2ampBalFMOOYODilGhjXZR/35NC8L39U3rlDZsG8
	vKvK7mtOWHTyrVL9tfv/ramhMVY6VzZfnaTQ97+9e/bWrJfVk14ai/Qz2m1K+HK+8NL19u5H
	kwUf+TaHe02osxFcJyBRxC46X+UV1/EfuqeSdJTXdeyOyE2YeWGr71zv5rZ7jVck397tLrZ7
	0RU18e3VX881V21WYinOSDTUYi4qTgQAJ9G7+doCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGIsWRmVeSWpSXmKPExsVy+t9jAV2j8lsBBm8uiltc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjHMn21gKNgtUTLq7hKmB
	sZ23i5GTQ0LARGLW/KUsELaYxIV769m6GLk4hAQWMUrcmjqPCcKZzSRxu3k/I0gVm4CaxJcv
	h9lBbBGBVIm/kxuZuxg5OJgFEiSuvfaAa76zYD3YVE4BK4kHZw8zgdjCAt4Sa54fYgWxWQRU
	JTYuOA02h1fAVqJ76w9WCFtQ4sfke2C9zAJaEut3HmeCsOUlNq95C7ZLQkBd4tFfXYgTnCQO
	rd/NDFEiIrHvxTvGCYxCs5BMmoVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85
	P3cTIzhyn0nvYFzVYHGIUYCDUYmHl/PXzQAh1sSy4srcQ4wSHMxKIrzOH4FCvCmJlVWpRfnx
	RaU5qcWHGH2AHp3ILCWanA9MKnkl8YbGJmZGlkZmFkYm5uY4hJXEeZs9UgKEBNITS1KzU1ML
	UotgxjFxcEo1MLZNVOxvebpgrt2L3Sp/V96/xHv6LcPW+OtBy62qThxZU7Hw6cMEpWmPwhUX
	nE7rsHl4Km/2+tirPBp//Atu3az+/mllRYST7TzxzOdLPplLVgRPWi6107Yo4HZX46aMaQKe
	l/okGFfz7BC5I+8aM3mbEMOHh9v+WAvV6EzWtRVsrd53O5J7T4YSS3FGoqEWc1FxIgBbPbTw
	CQMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 22, 2012 12:06 PM, Kukjin Kim wrote 
> Tejun Heo wrote:
> >
> > There's no need to test whether a (delayed) work item in pending
> > before queueing, flushing or cancelling it.  Most uses are unnecessary
> > and quite a few of them are buggy.
> >
> > Remove unnecessary pending tests from exynos_dp_core.  Only compile
> > tested.
> >
> > Signed-off-by: Tejun Heo <tj@kernel.org>
> > Cc: Kukjin Kim <kgene.kim@samsung.com>
> 
> Acked-by: Kukjin Kim <kgene.kim@samsung.com>

Acked-by: Jingoo Han <jg1.han@samsung.com>


I tested this patch with Exynos5250.
Also, taking it through the workqueue tree would be better.

Best regards,
Jingoo Han

> 
> > ---
> > Please let me know how this patch should be routed.  I can take it
> > through the workqueue tree if necessary.
> >
> Cc'ed Jingoo and Florian.
> 
> Now the exynos dp driver are being handled by Jingoo so let's waiting for
> his opinion to take this by himself or not.
> 
> - Kukjin Kim
> 
> > Thanks.
> >
> >  drivers/video/exynos/exynos_dp_core.c | 6 ++----
> >  1 file changed, 2 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/video/exynos/exynos_dp_core.c
> > b/drivers/video/exynos/exynos_dp_core.c
> > index 28fd686..3002a6a 100644
> > --- a/drivers/video/exynos/exynos_dp_core.c
> > +++ b/drivers/video/exynos/exynos_dp_core.c
> > @@ -1121,8 +1121,7 @@ static int __devexit exynos_dp_remove(struct
> > platform_device *pdev)
> >
> >  	disable_irq(dp->irq);
> >
> > -	if (work_pending(&dp->hotplug_work))
> > -		flush_work(&dp->hotplug_work);
> > +	flush_work(&dp->hotplug_work);
> >
> >  	if (pdev->dev.of_node) {
> >  		if (dp->phy_addr)
> > @@ -1144,8 +1143,7 @@ static int exynos_dp_suspend(struct device *dev)
> >  	struct exynos_dp_platdata *pdata = dev->platform_data;
> >  	struct exynos_dp_device *dp = dev_get_drvdata(dev);
> >
> > -	if (work_pending(&dp->hotplug_work))
> > -		flush_work(&dp->hotplug_work);
> > +	flush_work(&dp->hotplug_work);
> >
> >  	if (dev->of_node) {
> >  		if (dp->phy_addr)
> > --
> > 1.8.0.2

