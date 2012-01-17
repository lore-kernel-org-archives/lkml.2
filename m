Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752620Ab2AQJBq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 04:01:46 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:60918 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751340Ab2AQJBp convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 04:01:45 -0500
MIME-Version: 1.0
In-Reply-To: <4F153221.3080509@freemail.hu>
References: <4F12AB38.5040009@freemail.hu>
	<CACRpkdZ0osKrjTXsV96J5ckj=wC=OieHL7UTfjtm8ibHRuL6=A@mail.gmail.com>
	<4F153221.3080509@freemail.hu>
Date: Tue, 17 Jan 2012 10:01:45 +0100
Message-ID: <CACRpkdZEZ6X20mtP5reAq2UaG5f0DS_hMBN9L8LpV1O0tBkb-w@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio-pch: cleanup __iomem annotation usage
From: Linus Walleij <linus.walleij@linaro.org>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/17 Németh Márton <nm127@freemail.hu>:

> Hi Linux,

:-)

Common mistake, as are our brother Kubys who also
appear on the lists sometimes...

> You are right, the correct one should be "void __iomem *im_reg;" .
>
> Should I resend a patch for this?

Yep just send it with subject [PATCH 1/2 v2] atleast
that's what I usually do.

Yours,
Linus Walleij
