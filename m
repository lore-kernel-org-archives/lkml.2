Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3ADORS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 09:17:18 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:40125 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754741Ab3ADORP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 09:17:15 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdatZTFNFKL+8+EPkj0yRX8HSnwUu44dXrrWL1VBRPmwrA@mail.gmail.com>
References: <1355501979-1157-1-git-send-email-lee.jones@linaro.org>
	<CACRpkdatZTFNFKL+8+EPkj0yRX8HSnwUu44dXrrWL1VBRPmwrA@mail.gmail.com>
Date: Fri, 4 Jan 2013 15:17:14 +0100
Message-ID: <CACRpkdYvYLh-C2TxLuc_KB+LwQHL66NqhXGcpDgW_FB8e-4f=w@mail.gmail.com>
Subject: Re: [PATCH 00/21] gpio: ab8500: Bring AB8500 back to life
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, Grant Likely <grant.likely@secretlab.ca>,
        Patrice CHOTARD <patrice.chotard@st.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 3:18 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Dec 14, 2012 at 5:19 PM, Lee Jones <lee.jones@linaro.org> wrote:
>
>> The ab8500 GPIO driver is currently 'BROKEN', due to a lack of
>> updates and recent frame-work adoption. This patch-set aims to
>> bring the driver back to life so we may make use of it again.
>>
>> This first stage is to bring it into line with ST-Ericsson's
>> internal track, which has been keeping up-to-date. After these
>> patches have been accepted I will then overhaul the driver to
>> use the most recent APIs and frame-works, such as pinctrl and
>> Device Tree.
>>
>> Please give these patches an easy ride. I know they're not
>> perfect, but they do provide a great base on with I can form
>> the overhaul. Thanks for your understanding.
>
> OK I've applied these 21 patches on a branch in the pinctrl
> tree to be used as a merge base.

No I'll have to scrap this topic branch, as it does not compile.

Analysing the problem I see that part of the reason why it does
not compile is that it is adding stuff referencing the global
numberspace, like biasing.

Which is pinctrl business. So the proper feedback is that it
should be rewritten to use pinctrl.

Which is in the works.

So the plan is to mail out an all-in-one pinctrl replacement
patch instead, deleting the old AB8500 GPIO driver and
replacing it fully with a pinctrl driver.

Yours,
Linus Walleij
