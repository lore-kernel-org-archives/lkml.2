Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755214Ab2KZL1z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 06:27:55 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:39509 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2KZL1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 06:27:54 -0500
MIME-Version: 1.0
In-Reply-To: <20121126112628.GH12782@gmail.com>
References: <c0badc4f4021029a5de4393d7e3ca71494edb8ea.1353686946.git.viresh.kumar@linaro.org>
	<20121126112628.GH12782@gmail.com>
Date: Mon, 26 Nov 2012 16:57:53 +0530
Message-ID: <CAKohpo=sYeeigxs3V9_gz_AqT3wTbFPpVYXAA-gjoGWranRGkg@mail.gmail.com>
Subject: Re: [PATCH Resend] gpio: stmpe: Add DT support for stmpe gpio
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 November 2012 16:56, Lee Jones <lee.jones@linaro.org> wrote:
>> From: Vipul Kumar Samar <vipulkumar.samar@st.com>

>> +Optional properties:
>> + - norequest-mask: bitmask specifying which GPIOs should _not_ be requestable
>
> You have 'norequest-mask' here and 'st,norequest-mask' in the example.

> If 'st,norequest-mask' is truly required to be in the DT (I don't
> really understand it well enough to comment), and you fix up the
> inconsistency in the Documentation, you can apply my:
>
> Acked-by: Lee Jones <lee.jones@linaro.org>

Thanks for pointing out. Will fix it up.

--
viresh
