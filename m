Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab1L2Dom (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 22:44:42 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:50416 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab1L2Doi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 22:44:38 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-a1-4efbe206e37c
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Denis Kuzmenko'" <linux@solonet.org.ua>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>
References: <4EE7BE5F.8020108@solonet.org.ua>
 <01e501ccc536$a6e58fb0$f4b0af10$%kim@samsung.com>
 <4EFB83DE.7080404@solonet.org.ua>
In-reply-to: <4EFB83DE.7080404@solonet.org.ua>
Subject: RE: [PATCHv2 resend] Fix compilation error when
 CONFIG_CPU_FREQ_S3C24XX_DEBUGFS selected.
Date: Thu, 29 Dec 2011 12:44:04 +0900
Message-id: <029101ccc5dc$1c718360$55548a20$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Content-language: ko
Thread-index: AczFpNxnNJ7mwTCIRYOfHZc9Eg1JLwANmu+A
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote:
> 
> Hi Kukjin,
> 
Hi Denis,

> Your patch applies (note that it looks like your email-client have

Yeah, if over 76 columns, my e-mail client changes its line so maybe
happened wrapped long lines.

> wrapped long lines thus broke the path) and works OK. Looks good to me.
> See some additional comments below.
> 
> On 12/28/2011 09:59 AM, Kukjin Kim wrote:
> > Denis Kuzmenko wrote:
> (snip)
> >> +	depends on CPU_FREQ_S3C24XX && (S3C2410_IOTIMING ||
> >> S3C2412_IOTIMING)
> >
> > As you know, CONFIG_CPU_FREQ_S3C24XX_IODEBUG is for enabling of
> > s3c_freq_iodbg() and there is no problem when
> CONFIG_S3C241{0,2}_IOTIMING is
> > not selected, even though s3c_freq_iodbg() is used only at
> > s3c2410-iotiming.c now. So this is not necessary to fix the problem you
> > said.
> 
> I'm OK with this approach, however I don't see any future use of
> s3c_freq_iodbg() without s3c2410-iotiming.c. But it's not anyway
> critical so please pick any variant which you like.
> 
Yes. I think we need to sort out the CPUFREQ on S3C24XX next time :)

(snip)

> (snip)
> > So how about at below?
> > If you're ok, will send before v3.2.
> 
> So, as already said, I have no objections.
> And thank you for review.
> 

Thanks and Happy New Year!

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

