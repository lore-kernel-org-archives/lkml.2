Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab2AQIdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 03:33:39 -0500
Received: from relay01.digicable.hu ([92.249.128.189]:49348 "EHLO
	relay01.digicable.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413Ab2AQIdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 03:33:38 -0500
Message-ID: <4F153221.3080509@freemail.hu>
Date: Tue, 17 Jan 2012 09:32:33 +0100
From: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; hu-HU; rv:1.8.1.21) Gecko/20090402 SeaMonkey/1.1.16
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] gpio-pch: cleanup __iomem annotation usage
References: <4F12AB38.5040009@freemail.hu> <CACRpkdZ0osKrjTXsV96J5ckj=wC=OieHL7UTfjtm8ibHRuL6=A@mail.gmail.com>
In-Reply-To: <CACRpkdZ0osKrjTXsV96J5ckj=wC=OieHL7UTfjtm8ibHRuL6=A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Original: 78.131.104.232
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linux,

Linus Walleij wrote:
> 2012/1/15 Németh Márton <nm127@freemail.hu>:
> 
>> From: Márton Németh <nm127@freemail.hu>
>>
>> The __iomem annotation is to be used together with pointers used
>> as iowrite32() parameter. For more details see [1] and [2].
> (...)
>> -       u32 *im_reg;
>> +       u32 __iomem *im_reg;
> 
> Does it work to just say void __iomem *im_reg?
> 
> We usually don't type addresses.

You are right, the correct one should be "void __iomem *im_reg;" .

Should I resend a patch for this?

	Márton Németh

