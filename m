Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2GQABU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 20:01:20 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:16379 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab2GQABS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 20:01:18 -0400
X-AuditID: cbfee61b-b7f566d000005c8a-89-5004ab4cb376
From: Kukjin Kim <kgene.kim@samsung.com>
To: "=?UTF-8?Q?'Heiko_St=C3=BCbner'?=" <heiko@sntech.de>,
        "'Paul Bolle'" <pebolle@tiscali.nl>
Cc: "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1340619112.1773.155.camel@x61.thuisdomein>
 <201206251806.28081.heiko@sntech.de>
In-reply-to: <201206251806.28081.heiko@sntech.de>
Subject: RE: ARM: s3c2410: remove dead mach-s3c2410 directory
Date: Tue, 17 Jul 2012 09:01:16 +0900
Message-id: <144301cd63af$49c53520$dd4f9f60$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1S7IPDiy7smqPLTZ2F2wE05OSG2AQwagCA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsVy+t9jAV3f1SwBBmc3sllc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXMOf2crWAhX8WNb/MYGxj3cXcxcnJICJhInJh1hRnC
	FpO4cG89WxcjF4eQwCJGiRnrTzFBOH8ZJW71bGQCqWIT0JA4/P4ZO4gtIhAt8erqNrAOZoGd
	jBLNN56DFQkJxEksf7ISbCyngKHEn65JbCC2sICtxIEdf8BsFgFVifMbzoLZvEDxpe1n2SFs
	QYkfk++xgNjMAuoSk+YtYoawtSWevLvA2sXIAXSqusSjv7oQNxhJrN3xnA2iRERi34t3jBMY
	hWYhmTQLyaRZSCbNQtKygJFlFaNoakFyQXFSeq6RXnFibnFpXrpecn7uJkZwUD+T3sG4qsHi
	EKMAB6MSD6/QcpYAIdbEsuLK3EOMEhzMSiK802cBhXhTEiurUovy44tKc1KLDzFKc7AoifOa
	eH/1FxJITyxJzU5NLUgtgskycXBKNTA2TDx0a8r/Z6z3uUxNk2+/FW+/3yi5cV5Xi6hwtvMC
	6Uhey+qmn77n+/qumkXsK2e4zH3ZyuO/BEd2gdbKbV/5ps7eLV290NBw552/PmJnP9qd35TQ
	6ZD2MPVWbyb3rYBJ0knahkf+HFub/X8Z71+OVYdfc2Y0Ni/tlFa9eHiDO9feqrNN7n+UWIoz
	Eg21mIuKEwGg+eADZgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Heiko Stübner wrote:
> 
> Am Montag 25 Juni 2012, 12:11:52 schrieb Paul Bolle:
> > Commit 85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410: move
> > mach-s3c2410/* into mach-s3c24xx/") orphaned
> > arch/arm/mach-s3c2410/Kconfig: currently no other Kconfig file sources
> > that file. This means that the Kconfig symbols S3C2410_CPUFREQ and
> > S3C2410_PLLTABLE will never be set, which in turns means that the macros
> > CONFIG_S3C2410_CPUFREQ and CONFIG_S3C2410_PLLTABLE will never be
> > defined.
> >
> > All this makes that all four files in the mach-directory (Kconfig,
> > Makefile, cpu-freq.c, and pll.c) are effectively dead files since v3.4:
> > none of them can lead to any code in someones kernel. This directory can
> > safely be removed.
> 
> I don't think so. CPU-frequency-scaling on the earlier S3C architectures
> was
> probably working before the beginning of the directory merge.
> 
Yeah, maybe. But I think, sourcing mach-s3c2410/Kconfig is enough to fix working s3c24xx cpufreq.

> If I recall correctly Kgene was working on completing these missing pieces
> of
> the move to mach-s3c24xx.
> 
Yes, Heiko's memory is correct. But mainly my colleague is working it instead and I'm just helping him. As I know he needs more time probably it's not possible for upcoming merge window but next time, it's ok.

> The reason for noone complaining about the missing cpufreq support yet,
> might
> be that projects using the early S3C architectures hae not made it to the
> most
> recent kernel releases.
> 
Yeah, maybe. Anyway we should fix it as soon as possible...

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

