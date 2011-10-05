Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758104Ab1JEVHm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 17:07:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56443 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757872Ab1JEVHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 17:07:41 -0400
MIME-Version: 1.0
In-Reply-To: <1317801296.12133.0.camel@phoenix>
References: <1317801296.12133.0.camel@phoenix>
Date: Wed, 5 Oct 2011 23:07:39 +0200
X-Google-Sender-Auth: Jp-BAg68D90scdviLqWlxyZc6GM
Message-ID: <CAKnu2Mozhki9Cgst12HH=aqxFOnt3T4EbLm7eZyzTf_i_U0vQA@mail.gmail.com>
Subject: Re: [PATCH] leds: leds-lm3530: Add __devexit_p at necessary place
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Shreshtha Kumar SAHU <shreshthakumar.sahu@stericsson.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/5 Axel Lin <axel.lin@gmail.com>:

> According to the comments in include/linux/init.h:
>
> "Pointers to __devexit functions must use __devexit_p(function_name), the
> wrapper will insert either the function_name or NULL, depending on the config
> options."
>
> We have __devexit annotation for lm3530_remove(), thus add __devexit_p at
> necessary place.
>
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thanks Axel,
Linus Walleij
