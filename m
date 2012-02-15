Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761350Ab2BOJlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 04:41:17 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:37684 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135Ab2BOJlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 04:41:13 -0500
X-AuditID: cbfee61b-b7c62ae000000989-46-4f3b7db8fe73
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org, "'Namjae Jeon'" <linkinjeon@gmail.com>
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <000b01ccdc0a$0336abc0$09a40340$%jun@samsung.com>
 <CAKYAXd9pXfL1S_KSLoF48AKNtxj9-svdDdXp=_DYZAmBvFFddg@mail.gmail.com>
 <7d1016122f840cf62f669f06355b8605.squirrel@www.codeaurora.org>
In-reply-to: <7d1016122f840cf62f669f06355b8605.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Wed, 15 Feb 2012 18:41:12 +0900
Message-id: <004101ccebc5$f41b3450$dc519cf0$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczrsTzg17N14s5ETDCZU4cvun/w3wAE9Ocg
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Maya <merez@codeaurora.org> wrote:
> -----Original Message-----
> From: linux-mmc-owner@vger.kernel.org [mailto:linux-mmc-owner@vger.kernel.org] On Behalf Of
> merez@codeaurora.org
> Sent: Wednesday, February 15, 2012 4:13 PM
> To: Namjae Jeon
> Cc: Seungwon Jeon; linux-mmc@vger.kernel.org; Chris Ball; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH v4 2/2] mmc: core: Support packed command for eMMC4.5 device
> 
> > 2012/1/26 Seungwon Jeon <tgih.jun@samsung.com>:
> >> This patch supports packed command of eMMC4.5 device.
> >> Several reads(or writes) can be grouped in packed command
> >> and all data of the individual commands can be sent in a
> >> single transfer on the bus.
> >>
> >> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> >
> > Looks good to me also.
> > Thanks.
> Hi,
> 
> I'm running performance tests on this patch and would appreciate if you
> could wait with its approval until I'll have final conclusions (next
> week).
Thank you for test.

Best regards,
Seungwon Jeon.

> Thanks,
> Maya
> >> ---
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

