Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2ACIhm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 03:37:42 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:8389 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2ACIhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 03:37:40 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-40-4f02be530c66
From: Chanho Park <chanho61.park@samsung.com>
To: "'Linus Walleij'" <linus.walleij@linaro.org>
Cc: swarren@nvidia.com, Baohua.Song@csr.com, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>
References: <1325576871-9397-1-git-send-email-chanho61.park@samsung.com>
 <1325576871-9397-2-git-send-email-chanho61.park@samsung.com>
 <CACRpkdbnvZo4AN+yoeGwDaJ0yqOJT6VZO_9TmX4ZwdOCOE8Z5w@mail.gmail.com>
In-reply-to: <CACRpkdbnvZo4AN+yoeGwDaJ0yqOJT6VZO_9TmX4ZwdOCOE8Z5w@mail.gmail.com>
Subject: RE: [PATCH 1/2] pinctrl: correct a offset while enumerating pins
Date: Tue, 03 Jan 2012 17:37:39 +0900
Message-id: <008001ccc9f2$f38fadd0$daaf0970$%park@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=iso-8859-1
Content-transfer-encoding: 8BIT
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: AczJ7YYHahBG89eGSA+TK3O1Fy21rQAAPQEQ
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Linus Walleij [mailto:linus.walleij@linaro.org]
> Sent: Tuesday, January 03, 2012 4:59 PM
> To: Chanho Park
> Cc: swarren@nvidia.com; Baohua.Song@csr.com; linux-
> kernel@vger.kernel.org; Kyungmin Park
> Subject: Re: [PATCH 1/2] pinctrl: correct a offset while enumerating
> pins
> 
> On Tue, Jan 3, 2012 at 8:47 AM, Chanho Park <chanho61.park@samsung.com>
> wrote:
> 
> This:
> 
> > -               /* Pin space may be sparse */
> > +               /* Skip if we cannot search the pin */
> (...)
> > -               /* Pin space may be sparse */
> > +               /* Skip if we cannot search the pin */
> 
> I don't see why you're changing that comment, it is still true that
> the pin space may be sparse and that is what your patch confirms.
> 
> So I will restore that comment...

We do not concern that pin space is sparse
because we enumerate the pin space using the offset of array.
This situation is that we cannot search the pin from radix tree.
It is BUGON() or just skip this pin :)

Best regards,
Chanho Park

