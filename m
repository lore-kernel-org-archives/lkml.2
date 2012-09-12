Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758723Ab2ILNEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:04:51 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:65479 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab2ILNEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 09:04:48 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYbWEq5mhTcewmxEpcivXkVyQS_56QRU67G40zcRXnUCA@mail.gmail.com>
References: <1347016499-29354-1-git-send-email-lee.jones@linaro.org>
	<1347016499-29354-19-git-send-email-lee.jones@linaro.org>
	<CACRpkdYbWEq5mhTcewmxEpcivXkVyQS_56QRU67G40zcRXnUCA@mail.gmail.com>
Date: Wed, 12 Sep 2012 15:04:47 +0200
Message-ID: <CACRpkdaQHdxRZLMPZF6Ub4hcPhUc1ZK5goyGpBEWU2LqTGStaA@mail.gmail.com>
Subject: Re: [PATCH 18/19] gpio: Provide the tc3589x GPIO expander driver with
 an IRQ domain
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 3:10 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Sep 7, 2012 at 1:14 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> In preparation for Device Tree enablement all IRQ controllers
>> should control their own IRQ domain. This patch provides just
>> that for the tc3589x GPIO expander.
>>
>> CC: Grant Likely <grant.likely@secretlab.ca>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>
> Looks very good again,
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>
> I presume you will want to push the whole shebang through
> ARM SoC, but if that doesn't work out I am very tempted to
> apply this patch to the GPIO tree immediately so it lands
> in v3.7.

If I hear nothing I will probably apply this to the GPIO tree
tonight since it's a real nice patch and we really need irqdomain
conversion to happen all over the place... this driver has
many users so I want some rotation in linux-next for it.

Yours,
Linus Walleij
