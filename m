Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564Ab2GOKPJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 06:15:09 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36891 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689Ab2GOKPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 06:15:04 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.44.123]
In-Reply-To: <4FF50107.8030406@codeaurora.org>
References: <1341409019-32166-1-git-send-email-ohad@wizery.com> <4FF50107.8030406@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 15 Jul 2012 13:14:44 +0300
Message-ID: <CAK=WgbbO72S9=T-dnJBHE5d5k9H8dtYFtxe_AMSe+ut+0ZPOHg@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: adopt the driver core's alloc/add/del/put naming
To: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 5, 2012 at 5:50 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 7/4/2012 6:36 AM, Ohad Ben-Cohen wrote:
>> To make remoteproc's API more intuitive for developers, we adopt
>> the driver core's naming, i.e. alloc -> add -> del -> put. We'll also
>> add register/unregister when their first user shows up.
>>
>> Otherwise - there's no functional change here.
>>
>> Suggested by Russell King <linux@arm.linux.org.uk>.
>>
>> Cc: Russell King <linux@arm.linux.org.uk>
>
> Acked-by: Stephen Boyd <sboyd@codeaurora.org>

On Thu, Jul 5, 2012 at 2:50 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> I understand this patch and it's a good thing, so:
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>
> Yours,
> Linus Walleij

Thanks Linus and Stephen.

Applied.
