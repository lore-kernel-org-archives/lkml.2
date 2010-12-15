Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab0LOKwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 05:52:46 -0500
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:6033 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752602Ab0LOKwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 05:52:45 -0500
Message-ID: <37A8EACCFB5248EDA51F34DE0BC2F34A@hacdom.okisemi.com>
From: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
To: "Richard Cochran" <richardcochran@gmail.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>, "Arnd Bergmann" <arnd@arndb.de>
References: <4C612AA4.5040100@dsn.okisemi.com> <001001cb3ddb$9929d9a0$66f8800a@maildom.okisemi.com> <20100817090637.GC3330@riccoc20.at.omicron.at> <201008171325.55761.arnd@arndb.de> <884C7BF624424621917562DB0C3E15E7@hacdom.okisemi.com> <20101214162100.GA10667@riccoc20.at.omicron.at>
Subject: Re: [MeeGo-dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to 2.6.35
Date: Wed, 15 Dec 2010 19:52:42 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="UTF-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5931
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5994
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

Thank you for your PTP core's status information.
Accepted by upstream, we will start our development.

Thanks,
---
Tomoya MORINAGA
OKI SEMICONDUCTOR CO., LTD.

----- Original Message ----- 
From: "Richard Cochran" <richardcochran@gmail.com>
To: "Tomoya MORINAGA" <tomoya-linux@dsn.okisemi.com>
Cc: "Arnd Bergmann" <arnd@arndb.de>; "LKML" <linux-kernel@vger.kernel.org>
Sent: Wednesday, December 15, 2010 1:21 AM
Subject: Re: [MeeGo-dev][PATCH] Topcliff: Update PCH_IEEE1588 driver to 
2.6.35


> On Tue, Dec 14, 2010 at 04:46:03PM +0900, Tomoya MORINAGA wrote:
>> We want to implement IEEE1588 driver for Intel EG20T PCH (Topcliff)
>> using PTP core according to you saying.
>
> That is good news.
>
>> However, it seems PTP core module is not accepted by upstream.
>> How about your PTP status ?
>
> I posted v6 back on September 23. Based on the comments, I think the
> patch set is almost good enough for mainline inclusion (at least, I
> hope so).
>
> I am just getting ready to post v7, and the kernel interface will
> change a bit. I will post it before Christmas, so perhaps you can wait
> a bit. You can take look at the v6 code, since the general ideas will
> not change very much.
>
> Thanks,
> Richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

