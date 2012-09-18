Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758038Ab2IRLWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 07:22:10 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51626 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758014Ab2IRLWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 07:22:07 -0400
MIME-Version: 1.0
In-Reply-To: <20120914080347.GB3374@gmail.com>
References: <1344256323-10484-1-git-send-email-lee.jones@linaro.org>
	<CACRpkdaKa=NAObnjJyifhxyqu3Hcgj7Fxqi=bdNFqbm7V_8cSw@mail.gmail.com>
	<20120914080347.GB3374@gmail.com>
Date: Tue, 18 Sep 2012 13:22:06 +0200
Message-ID: <CACRpkdbntZ2k+2mi7=nCL2RV+YcbYi=wbK2RaDKsKNKqsCxMOA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Input: ab8500-ponkey: Make the distinction between DT
 and non-DT boots
From: Linus Walleij <linus.walleij@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Lee Jones <lee.jones@linaro.org>
Cc: arnd@arndb.de, arm@kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 10:03 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, Sep 13, 2012 at 11:35:43AM +0200, Linus Walleij wrote:
>>
>> Not having this patch in v3.6-rcN gives the following boot noise (and
>> the key does not work):
>>
>> ------------[ cut here ]------------
>> WARNING: at /home/elinwal/linux-stericsson/kernel/irq/irqdomain.c:137
>> irq_domain_legacy_revmap+0x20/0x48()
(...)
> I haven't tested this, but I think this patch should be pulled out
> of -next and pushed into the -rcs to fix the issue you see above.
> The real fix along with the revert to this patch also resides in
> -next and will be applied during the next merge window.

Dmitry, can you fix this?

v3.6-rc6 is regressing on us...

Yours,
Linus Walleij
