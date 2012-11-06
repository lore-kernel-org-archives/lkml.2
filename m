Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab2KFI5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2012 03:57:42 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:48614 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314Ab2KFI5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2012 03:57:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAJuYYwTg0V3sn0YW-bJV9T9EZ91dF7wjX9UmeBwtxMZzJMwwjg@mail.gmail.com>
References: <1352130296.13561.1.camel@phoenix>
	<CAJuYYwTg0V3sn0YW-bJV9T9EZ91dF7wjX9UmeBwtxMZzJMwwjg@mail.gmail.com>
Date: Tue, 6 Nov 2012 09:57:40 +0100
Message-ID: <CACRpkdZXm=QdDUZ3Mdt0uZ7Y8i24AgMRzgBLsiWbJTCPH1nFUw@mail.gmail.com>
Subject: Re: [PATCH v2] pinctrl: samsung: Add ifdef CONFIG_OF_GPIO guard for gc->of_node
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: Axel Lin <axel.lin@ingics.com>, Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 6:03 AM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:
> On 5 November 2012 21:14, Axel Lin <axel.lin@ingics.com> wrote:

>> +#if defined(CONFIG_OF_GPIO)
>>                 gc->of_node = bank->of_node;
>> +#endif
>
> The samsung pinctrl driver supports only device tree enabled
> platforms. So instead of adding the above #if, would it not be better
> to add 'select OF_GPIO' for Samsung pinctrl driver in
> drivers/pinctrl/Kconfig. ?

Or edit the Samsung driver to depend on OF_GPIO, this is probably
better.

Yours,
Linus Walleij
