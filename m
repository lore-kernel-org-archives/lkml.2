Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759282Ab2ILPx3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 11:53:29 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:49580 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674Ab2ILPx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 11:53:27 -0400
MIME-Version: 1.0
In-Reply-To: <50505959020000780009AC53@nat28.tlf.novell.com>
References: <504DF63A020000780009A30B@nat28.tlf.novell.com>
	<CACRpkdbCmou3wTXJjPhSaCH0kH1VrU5n-9t7NTJOjFQs1xH+cA@mail.gmail.com>
	<50505959020000780009AC53@nat28.tlf.novell.com>
Date: Wed, 12 Sep 2012 17:53:26 +0200
Message-ID: <CACRpkdZ6me3t4oUNg2QNjVgFw_gfJvgR4PZzE+vX+7W8PTgcNg@mail.gmail.com>
Subject: Re: [PATCH] allow gpiolib to be a module
From: Linus Walleij <linus.walleij@linaro.org>
To: Jan Beulich <JBeulich@suse.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 9:43 AM, Jan Beulich <JBeulich@suse.com> wrote:

>> I can't parse this, sorry the gpio subsystem maintainer is too bad coder.
>> What about something more readable?
>>
>> int ret;
>>
>> ret = gpiolib_sysfs_init();
>> if (ret)
>>    return ret;
>> return gpiolib_debugfs_init();
>>
>> I know it doesn't look as cool but it's easier for me to understand.
>
> Okay, since you're the second one to complain despite there
> being other uses of the construct in the same source file, I'll
> replace it, ...

Sorry about that, but two wrongs does not make one right.
I'd be happy if you patch the other constructs too...

Yours,
Linus Walleij
