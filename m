Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750982Ab2FRLwJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:52:09 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:38155 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696Ab2FRLwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaNF-Tgz_ncnrJp7xsCbGWEgcfmj_yuY0Q8EiWRt-g0rFw@mail.gmail.com>
References: <CAHdPZaNF-Tgz_ncnrJp7xsCbGWEgcfmj_yuY0Q8EiWRt-g0rFw@mail.gmail.com>
Date: Mon, 18 Jun 2012 13:52:06 +0200
Message-ID: <CACRpkda5nYmAT3-fkxdYQEGpi6U=L-kphQEu3naoxPzO9a-7pQ@mail.gmail.com>
Subject: Re: Q: return of pinctrl_register and handing at drivers that use
 this function
From: Linus Walleij <linus.walleij@linaro.org>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 1:47 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:

> since the pinctrl_register returns a pointer of structure type "struct
> pinctrl_dev" or NULL if it was failed to register the pinctrl driver,
> so IS_ERR checking is not required?

Yes. (Unless I did something wrong.)

> My understanding about IS_ERR is that its used when the pointer
> addresses are kind of error codes rather actual addresses,
> but are a kind of return codes of functions returning integer types.

You are absolutely right.

Yours,
Linus Walleij
