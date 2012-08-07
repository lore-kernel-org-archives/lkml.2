Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606Ab2HGU3N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:29:13 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:54915 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751184Ab2HGU3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:29:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Dongjin Kim <Dongjin.Kim@agreeyamobility.net>
Subject: Re: 
 =?euc-kr?q?=C8=B8=BD=C5=3A_=5BPATCH_2/4=5D_arm/dts=3A_exynos4=3A_Add_DTS?=
 =?euc-kr?q?_files_derived_from_common?= Exynos4
Date: Tue, 7 Aug 2012 20:29:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Dongjin Kim <tobetter@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1344366398-19022-1-git-send-email-dongjin.kim@agreeyamobility.net> <201208071938.26507.arnd@arndb.de> <A6A3B7488C419F488E5B13FFD03C08AD2F4372EB@SN2PRD0510MB370.namprd05.prod.outlook.com>
In-Reply-To: <A6A3B7488C419F488E5B13FFD03C08AD2F4372EB@SN2PRD0510MB370.namprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201208072029.08693.arnd@arndb.de>
X-Provags-ID: V02:K0:FMZ6Jp+DFrxzfuLdGb04ujQM1mHkGSciDOJYG6C+Xxw
 Vz/J58fddpMPhDKKewVJQMdr43lLIBcndidx57ypONG5lc6i7Y
 wbUj2c36glxIQSMe7DdUegcqu8bH197Ug3a8EMwCz/zHDFcb5t
 5j2kgc4ikwtef6RIcLWSTWbAib3vjDq4Vv6luRLsnecIfscoUw
 ivfLwHsPKO7W2FOl6UJcvrZHqzA5z7TO/Qq34I+/O19bIaNmOp
 xOS5SeihVeI38b5ESMBcG5XU5gehWEXd2FJeGZQx28m/o6szLm
 PTcsLd58EyH0aIoy0G2TgBwfOZlNUToWK7vMIKjVXqiYLRcWYv
 48FD4ergTry5LFXsSJm4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 August 2012, Dongjin Kim wrote:
> Hi,
> 
> I didn't use -M and I couldn't see any difference with the it.
> Did I make something wrong on that patch?

No, I think it's just git being less smart about file moves than I was hoping
for. It might do the right thing if you do the patch in two steps:

1. rename exynos4210.dtsi to exynos4.dtsi and add a one-line exynos4210.dtsi
file that just includes exynos4.dtsi.

2. do all the changes for moving contents back from exynos4.dtsi into
exynos4210.dtsi and exynos4412.dtsi.

Not sure if it's worth it though. Your version is probably good enough
if there are no tools to do a better job automatically.

	Arnd
