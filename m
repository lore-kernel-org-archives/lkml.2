Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0KZRL1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:11:27 -0500
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:42564 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753724Ab0KZRL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:11:26 -0500
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: zhDGfpkVM1mIk.sXC7Xcc7NzoXQDRJvRFPt7iZptGzK6KZe
 BstNIbPSsRKtbp7GaWIMh7HJcv.gZTKpJDaYh0LnmZNDH6pLMHGyJd7kOi6S
 _gl0SAm0_x7h51CYEeZnGLaWyMz.0_6kV.SRxgnpGX6uts0YAFvuWX2dPAjo
 yfjMnvTCQBI68Xrg2Ku6G91yU0ke8uPqurEKH9.gvfO3HWln3WdH3QjmBSLc
 L31vkFHMYIoDNFyXbO3i89_IX82jLzSkjmXt8E7I-
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 26 Nov 2010 11:11:22 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, heiko.carstens@de.ibm.com, tglx@linutronix.de,
        mingo@elte.hu
Subject: Re: [PATCH] printk: use this_cpu_{read|write} api on
 printk_pending
In-Reply-To: <1290790791.2855.259.camel@edumazet-laptop>
Message-ID: <alpine.DEB.2.00.1011261109500.13524@router.home>
References: <20101126120235.406766476@de.ibm.com>  <tip-61ab25447ad6334a74e32f60efb135a3467223f8@git.kernel.org>  <1290788536.2855.237.camel@edumazet-laptop>  <alpine.DEB.2.00.1011261038360.13524@router.home> <1290790791.2855.259.camel@edumazet-laptop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010, Eric Dumazet wrote:

> I guess you read the changelog too fast ;)

No I only read the code.... ;-)

> I posted this patch after noticing printk_needs_cpu() was always used
> for the current cpu.

Ok.

> We have other functions around, that always work for the current cpu.

Ok.

> We pass cpu as a parameter, mostly because smp_processor_id() was a bit
> expensive in old kernels, and is still expensive because of sanity
> tests.

I thought sanity tests do not apply for performance testing scenarios?

smp_processor_id() is usually a simple per cpu data access and very fast.

