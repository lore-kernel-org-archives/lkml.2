Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2AQWuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 17:50:17 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33705 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756138Ab2AQWuP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 17:50:15 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdZEZ6X20mtP5reAq2UaG5f0DS_hMBN9L8LpV1O0tBkb-w@mail.gmail.com>
References: <4F12AB38.5040009@freemail.hu> <CACRpkdZ0osKrjTXsV96J5ckj=wC=OieHL7UTfjtm8ibHRuL6=A@mail.gmail.com>
 <4F153221.3080509@freemail.hu> <CACRpkdZEZ6X20mtP5reAq2UaG5f0DS_hMBN9L8LpV1O0tBkb-w@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 17 Jan 2012 15:49:54 -0700
X-Google-Sender-Auth: MlRq-_Q0YoGds_WcM2K07zthDBs
Message-ID: <CACxGe6t2xtm-T43cBcbaqTrnPST9+R8E7dhq1rJnC+4P2__JRQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio-pch: cleanup __iomem annotation usage
To: Linus Walleij <linus.walleij@linaro.org>
Cc: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/17 Linus Walleij <linus.walleij@linaro.org>:
> 2012/1/17 Németh Márton <nm127@freemail.hu>:
>
>> Hi Linux,
>
> :-)
>
> Common mistake, as are our brother Kubys who also
> appear on the lists sometimes...
>
>> You are right, the correct one should be "void __iomem *im_reg;" .
>>
>> Should I resend a patch for this?
>
> Yep just send it with subject [PATCH 1/2 v2] atleast
> that's what I usually do.

Actually, I've already applied it.  Send a follow-on patch.  It is
logically a separate change anyway since the existing code already
uses u32.

g.
