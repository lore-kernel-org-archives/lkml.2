Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754090Ab1LUWEg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 17:04:36 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:65110 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab1LUWEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 17:04:33 -0500
X-AuditID: cbfee61b-b7b95ae00000198b-52-4ef257ef1c05
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Denis Kuzmenko'" <linux@solonet.org.ua>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>
References: <4EE7BE5F.8020108@solonet.org.ua>
 <064501ccbfae$cf1e5cb0$6d5b1610$%kim@samsung.com>
 <4EF23852.1050304@solonet.org.ua>
In-reply-to: <4EF23852.1050304@solonet.org.ua>
Subject: RE: [PATCHv2 resend] Fix compilation error when
 CONFIG_CPU_FREQ_S3C24XX_DEBUGFS selected.
Date: Thu, 22 Dec 2011 07:04:28 +0900
Message-id: <06fa01ccc02c$828b6810$87a23830$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczAGj9DFGCEn5JhRHyX4RZqRN4Z3AAEfxng
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote:
> 
> On 12/21/2011 09:04 AM, Kukjin Kim wrote:
> > Denis Kuzmenko wrote:
> >>
> >> Fix compilation error when CONFIG_CPU_FREQ_S3C24XX_DEBUGFS selected.
> >>
> >> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> >> ---
> >>
> >> Patch is against 3.2-rc4.
> >> CONFIG_S3C2410_IOTIMING is not selected for MACH_MINI2440. Because of
> this
> >> the
> >> file s3c2410-iotiming.c is not ever compiled and enabling
> >> CONFIG_CPU_FREQ_S3C24XX_DEBUGFS option caused undefined reference to
> >> function
> >> s3c2410_iotiming_debugfs defined in that file. s3c2410_iotiming_debugfs
> >> defined
> >> as NULL for this case.
> >>
> > Hi Denis,
> >
> > Well, there is no error when CONFIG_CPU_FREQ_S3C24XX_DEBUGFS selected in
> my
> > case and s3c2410-iotiming.c is built...when is it happened? I just
> selected
> > every regarding configuration in kernel menuconfig...
> 
> Please, try attached config (it's still failing in v3.2-rc6).
> 
Hi Denis,

Yes, when s3c2410 stuff is not selected, it happened.
Look at me soon and thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

