Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031652Ab2CGAR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:17:27 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:38650 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932670Ab2CGAR0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:17:26 -0500
X-AuditID: cbfee61a-b7b78ae000001ceb-5e-4f56a915b61f
From: Seungwon Jeon <tgih.jun@samsung.com>
To: merez@codeaurora.org, "'Namjae Jeon'" <linkinjeon@gmail.com>
Cc: linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
References: <4934441a17d25c3249556f7bf281b1be.squirrel@www.codeaurora.org>
 <CAKYAXd_6OqQJ78mPJp11gRvGwwg88S_n_Auu=_HdP_ZXzCKrDg@mail.gmail.com>
 <6669559e86c1d13b27e941ff2acf89d2.squirrel@www.codeaurora.org>
 <CAKYAXd8HMrdB9mzgsz5XmMxkDE+gMce+CTEDFU4J67nusNtLOg@mail.gmail.com>
 <cf2950fbeb4c500534be670cdd8cf85d.squirrel@www.codeaurora.org>
In-reply-to: <cf2950fbeb4c500534be670cdd8cf85d.squirrel@www.codeaurora.org>
Subject: RE: [PATCH v5 2/2] mmc: core: Support packed command for eMMC4.5 device
Date: Wed, 07 Mar 2012 09:17:24 +0900
Message-id: <000001ccfbf7$ac3e7510$04bb5f30$%jun@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acz7oxeJ5VIyI3u0SZab75XIrzc7ogAT/tRQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Maya Erez <merez@codeaurora.org> wrote:
> > Hi. Merez.
> >
> > Thanks a lot about your performance measurement.
> >
> > I think that your measurement is enough and correct and the firmware
> > of mmc vender should be optimized or change properly rather than
> > modifying the current patch.
> >
> > And currently we can use only write packed cmd by my suggestion.
> >
> > I would like to add my reviewd-by tag in updated patches also.
> >
> > Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>
> >
> > Thanks.
> 
> I tend to disagree. Adding a massive amount of code that would be disabled
> can be risky. In case this code will not be in use it will not be properly
> tested and its reliability will be uncertain.
> 
If you found something to be correct, please let me know that.
It would be rightly appreciated.

Best regards,
Seungwon Jeon.

> Thanks,
> Maya Erez
> Consultant for Qualcomm Innovation Center, Inc.
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-mmc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

