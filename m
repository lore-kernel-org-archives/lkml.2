Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654Ab1CPMnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 08:43:32 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61959 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab1CPMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 08:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Uiv/fKqOcYcXkacX2TTYxuFHFvA690R3x4D9IIgB6mg/kquanXU2vYOaMgi8njSdQS
         2HxebbVWBnXfmCyETOzgaPAOwQAp1ahUoolksOtSYXqtiC+LJ03Q8ec9stIvEdrTnTpM
         oK7m1/X7QqeWF7M00yBd1S+RRzBDKacnxtk9g=
MIME-Version: 1.0
In-Reply-To: <1300275412.3432.46.camel@odin>
References: <1299857178-5221-1-git-send-email-linus.walleij@stericsson.com>
	<20110311153134.GO1760@opensource.wolfsonmicro.com>
	<AANLkTinD9fO9Tyft0CQABMea2SbcHexNmYT9_ND_Yb-M@mail.gmail.com>
	<20110314181531.GA32434@opensource.wolfsonmicro.com>
	<AANLkTi=W980GYHVxdYPV3xNKcdGpjAewKssoUc3ZoEDi@mail.gmail.com>
	<1300275412.3432.46.camel@odin>
Date: Wed, 16 Mar 2011 13:43:25 +0100
X-Google-Sender-Auth: KEYquN7uvGLTI90Af2ti6z_w0CY
Message-ID: <AANLkTiks-D6QfoXmsJv_VPh-v4kZfjR29c6gpG5bW_vk@mail.gmail.com>
Subject: Re: [PATCH] regulator: switch the ab3100 to use enable_time()
From: Linus Walleij <linus.walleij@linaro.org>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Mattias Wallin <mattias.wallin@stericsson.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/16 Liam Girdwood <lrg@slimlogic.co.uk>:

> Btw, you have a few other regulator patches recently in amongst MFD and
> ARM updates. I assume these will go via MFD ?

The TPS6105x stuff will go through MFD, hopefully.

There are two other AB8500 regulator patches which are ripe
for merge through the regulator tree right now, and that's the
ones with Subjects:

"[PATCH 1/4] regulator: add support for USB voltage regulator"
"[PATCH 3/4] regulator: initialization for ab8500 regulators"

Both have Mark's ACK, and I think they apply cleanly in
that order. If there are any problems, tell me and I'll respin.

The platform data [4/4] can be applied out-of-order so I will
bring that in later.

The last patch [2/4] needs some refactoring and a consumer
interface that I'm working on in accordance with Mark's
directions, but that's a separate issue.

Yours,
Linus Walleij
