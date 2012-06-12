Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753092Ab2FLMeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 08:34:19 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50432 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab2FLMeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 08:34:18 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdb0TefNMcXyTRkz6Kv5FifJMmSoXzFTQgKhCt6B0T5sDA@mail.gmail.com>
References: <1339183331-4108-1-git-send-email-devendra.aaru@gmail.com>
	<CACRpkdb0TefNMcXyTRkz6Kv5FifJMmSoXzFTQgKhCt6B0T5sDA@mail.gmail.com>
Date: Tue, 12 Jun 2012 18:04:17 +0530
Message-ID: <CAHdPZaMEiJrDdw66KkODd_VuomV0TY6qPZn1z_W48j++ed5YJA@mail.gmail.com>
Subject: Re: [PATCH 1/2] pinctrl: pinctrl-imx: free allocated pinctrl_map
 structure only once and use kernel facilities for IMX_PMX_DUMP
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Dong Aisheng <aisheng.dong@freescale.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 4:31 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
>> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>
>
> OK I applied this, which I *think* is the last version of the patch,
> please double-check that the right one is in my git.
>
Yeah correct This is the Latest one.
Thanks for taking this in.
> This was send the 9th but not tagged v3 so I was a bit confused...
>
Sorry for not changing the subject to V3 for this.

so for every review, do we need to increment version count of the patch?
> Yours,
> Linus Walleij
