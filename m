Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756390Ab2FTRIx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 13:08:53 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49772 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753751Ab2FTRIw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 13:08:52 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZAg8A2kms=mWvE6-HpMQcW_GskHze=4_Psn9_6zL7k9g@mail.gmail.com>
References: <CAHdPZaNF-Tgz_ncnrJp7xsCbGWEgcfmj_yuY0Q8EiWRt-g0rFw@mail.gmail.com>
	<CACRpkda5nYmAT3-fkxdYQEGpi6U=L-kphQEu3naoxPzO9a-7pQ@mail.gmail.com>
	<CAHdPZaPFtO1bRC3TdLx8MSgFMznr5FBXV5DdUyasNAcF34s3mQ@mail.gmail.com>
	<CACRpkdYB9wPuCH=U3V5EJAhj6Ob2HowUFYT7Q0nqtOYyf7asUQ@mail.gmail.com>
	<CAHdPZaPYbDSkeb__kESpoU46fheNuPHOA2uOhVDnyAyWZriHyQ@mail.gmail.com>
	<CACRpkdZAg8A2kms=mWvE6-HpMQcW_GskHze=4_Psn9_6zL7k9g@mail.gmail.com>
Date: Wed, 20 Jun 2012 22:38:51 +0530
Message-ID: <CAHdPZaP-NCQt2Y1QVgX_Hqa94tScfR--R+w25j8jV08YUmUZZA@mail.gmail.com>
Subject: Re: Q: return of pinctrl_register and handing at drivers that use
 this function
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Wed, Jun 20, 2012 at 1:22 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> I mean it shall be tested like this:
>
> if (!pinmctrl_register(&foo)) {
>    /* error case */
> }
>
> No IS_ERR() business.
>
Yeah, and you already took the changes into your brach :-). Thanks!
> Linus

Devendra
