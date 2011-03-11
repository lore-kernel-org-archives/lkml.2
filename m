Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab1CKDsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 22:48:15 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:36919 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751077Ab1CKDsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 22:48:12 -0500
Date: Fri, 11 Mar 2011 12:46:30 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: linux-next: manual merge of the cpufreq tree with the s5p tree
In-reply-to: <20110311024101.GA29265@redhat.com>
To: "'Dave Jones'" <davej@redhat.com>, "'Stephen Rothwell'" <sfr@au1.ibm.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Rafael J. Wysocki'" <rjw@sisk.pl>
Message-id: <00e901cbdf9e$f0842510$d18c6f30$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: Acvflcd6TuHHQ8woTBmPEjg1xiOlwQABtLoA
References: <20110311133542.8ffb094e.sfr@au1.ibm.com>
 <20110311024101.GA29265@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> 
> On Fri, Mar 11, 2011 at 01:35:42PM +1100, Stephen Rothwell wrote:
>  > Hi Dave,
>  >
>  > Today's linux-next merge of the cpufreq tree got a conflict in
>  > arch/arm/mach-exynos4/cpufreq.c between commit 7d30e8b3815f ("ARM:
>  > EXYNOS4: Add EXYNOS4 CPU initialization support") from the s5p tree and
>  > commit 44033b9c940e ([CPUFREQ] Remove the pm_message_t argument from
>  > driver suspend"") from the cpufreq tree (where this file is called
>  > arch/arm/mach-s5pv310/cpufreq.c).
>  >
>  > Just context changes.  I fixed it up (see below) and can carry the fix
as
>  > necessary.
> 
> Yep, Looks fine to me. thanks.
> 
> 	Dave

Of course, it's ok to me too.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

