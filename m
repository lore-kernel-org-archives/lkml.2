Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab2FRMEy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:04:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41472 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab2FRMEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:04:53 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkda5nYmAT3-fkxdYQEGpi6U=L-kphQEu3naoxPzO9a-7pQ@mail.gmail.com>
References: <CAHdPZaNF-Tgz_ncnrJp7xsCbGWEgcfmj_yuY0Q8EiWRt-g0rFw@mail.gmail.com>
	<CACRpkda5nYmAT3-fkxdYQEGpi6U=L-kphQEu3naoxPzO9a-7pQ@mail.gmail.com>
Date: Mon, 18 Jun 2012 17:34:53 +0530
Message-ID: <CAHdPZaPFtO1bRC3TdLx8MSgFMznr5FBXV5DdUyasNAcF34s3mQ@mail.gmail.com>
Subject: Re: Q: return of pinctrl_register and handing at drivers that use
 this function
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Mon, Jun 18, 2012 at 5:22 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Mon, Jun 18, 2012 at 1:47 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
>
>> since the pinctrl_register returns a pointer of structure type "struct
>> pinctrl_dev" or NULL if it was failed to register the pinctrl driver,
>> so IS_ERR checking is not required?
>
> Yes. (Unless I did something wrong.)
>
So checking the return value of pinctrl_register with IS_ERR is not required.
There are drivers in pinctrl subsystem which uses the IS_ERR and may (not)
check whether its null or not.

you can expect a patchset of those fixes. :)
> Yours,
> Linus Walleij

Thanks,
Devendra.
