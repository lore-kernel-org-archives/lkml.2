Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122Ab2GQAHu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 20:07:50 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:19574 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2GQAHk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 20:07:40 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-8a-5004accb66b3
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Paul Bolle'" <pebolle@tiscali.nl>,
        "'Simtec Linux Team'" <linux@simtec.co.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <1340619670.1773.162.camel@x61.thuisdomein>
In-reply-to: <1340619670.1773.162.camel@x61.thuisdomein>
Subject: RE: BAST: update MAINTAINERS entry
Date: Tue, 17 Jul 2012 09:07:39 +0900
Message-id: <144401cd63b0$2dbd7f80$89387e80$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1SvEDp4OhStI1WT16Ot5WT8B2WgQQ8ybjA
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsVy+t9jQd3Ta1gCDG40yVhc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M+dOjC7ZyVXz/v5KpgfEaRxcjJ4eEgIlEY9sENghbTOLCvfVA
	NheHkMB0RolpnzYzQzjzmCTm9t9lBKliE9CQOPz+GTuILSIwn1Hi3yF7EJtZIE/i86RuoG4O
	oAZzia+90iBhTgELiXnLDzKDhIUFtCUmnUoCCbMIqErs3tfPCmLzCthKzH74gg3CFpT4Mfke
	C8REdYlJ8xYxQ9jaEk/eXWAFGSMBFH/0VxfEFBEwkjiwSwyiQkRi34t3jBMYhWYhGTQLyaBZ
	SAbNQtKygJFlFaNoakFyQXFSeq6hXnFibnFpXrpecn7uJkZwAD+T2sG4ssHiEKMAB6MSD++K
	FSwBQqyJZcWVuYcYJTiYlUR4p88CCvGmJFZWpRblxxeV5qQWH2KU5mBREuc19v7qLySQnliS
	mp2aWpBaBJNl4uCUamAUamXX+ClQz3HD8IJ+2++oJ2u4W1v8J00Lucz/irWFJyLj4DLdGb61
	Pr/kBFIcfmzQem8bdishT3Lm9KDnDNWK1w6GslRlf5mcuEVRfmKJxU+FR8Z7RFufbDPy+iDx
	5slMY78txoF93NI7mQ09dkqXZ54qlrr0PJynOeRu6ZJboV6THC50BymxFGckGmoxFxUnAgBn
	BE/mXAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Bolle wrote:
> 
> Commit 85fd6d63bf2927b9da7ab1b0d46723bfdb13808c ("ARM: S3C2410: move
> mach-s3c2410/* into mach-s3c24xx/") moved the three files mentioned in
> the "SIMTEC EB2410ITX (BAST)" MAINTAINERS entry to the arch/arm/s3c24xx
> directory. Update that entry accordingly.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
>  MAINTAINERS |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index eb22272..df09359 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -6145,9 +6145,9 @@ P:	Vincent Sanders <vince@simtec.co.uk>
>  M:	Simtec Linux Team <linux@simtec.co.uk>
>  W:	http://www.simtec.co.uk/products/EB2410ITX/
>  S:	Supported
> -F:	arch/arm/mach-s3c2410/mach-bast.c
> -F:	arch/arm/mach-s3c2410/bast-ide.c
> -F:	arch/arm/mach-s3c2410/bast-irq.c
> +F:	arch/arm/mach-s3c24xx/mach-bast.c
> +F:	arch/arm/mach-s3c24xx/bast-ide.c
> +F:	arch/arm/mach-s3c24xx/bast-irq.c
> 
>  TI DAVINCI MACHINE SUPPORT
>  M:	Sekhar Nori <nsekhar@ti.com>
> --
> 1.7.7.6

OK, looks good to me, but I'm not sure Simtec Linux Team and Vincent are still supporting BAST?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

