Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130Ab2KGBFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 20:05:17 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:42539 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab2KGBFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 20:05:14 -0500
MIME-Version: 1.0
In-Reply-To: <509886A2.5060509@wwwdotorg.org>
References: <1352170552-29564-1-git-send-email-omar.luna@linaro.org>
	<1352170552-29564-2-git-send-email-omar.luna@linaro.org>
	<509886A2.5060509@wwwdotorg.org>
Date: Tue, 6 Nov 2012 19:05:13 -0600
Message-ID: <CALLhW=5AypWUzRbCkO4fKO=qAtUPTC3H8VjHgXWV_uFUp=GJzA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] mailbox: OMAP: introduce mailbox framework
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 5 November 2012 21:40, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/05/2012 07:55 PM, Omar Ramirez Luna wrote:
>> Actually moving it from plat-omap, as this framework/driver code is
>> supposed to be under drivers/ folder. The framework should work with
>> the current supported OMAP processors (OMAP1+) that have mailbox and
>> can be used as a method of interprocessor communication.
>>
>> The mailbox hardware (in OMAP) uses a queued mailbox-interrupt mechanism
>> that provides a communication channel between processors through a set of
>> registers and their associated interrupt signals by sending and receiving
>> messages.
>
>> diff --git a/drivers/mailbox/mailbox.h b/drivers/mailbox/mailbox.h
>
> Is this a public interface to the driver? If so, shouldn't the header be
> in include/linux somewhere?
>
> Is this a generic interface to any mailbox driver? If so, then I don't
> think having "omap" in the symbol names is appropriate. If the header is
> specific to the OMAP driver, I don't think using the very generic
> filename "mailbox.h" is appropriate; use omap_mailbox.h instead?

It was a mixture between the two, the next patch splits the API from
the mailbox driver interfaces.

I kept the files named as plain mailbox.[ch], in hopes that we could
progress with the cleanup after moving the files from plat-omap, as it
seems they interfere with the current single Image effort, but if it
is preferred (as it seems to be) I can resend again after removing the
omap_ prefixes from the intended-to-be generic code.

Thanks,

Omar
