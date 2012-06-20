Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755281Ab2FTHwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:52:09 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59390 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab2FTHwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:52:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdPZaPYbDSkeb__kESpoU46fheNuPHOA2uOhVDnyAyWZriHyQ@mail.gmail.com>
References: <CAHdPZaNF-Tgz_ncnrJp7xsCbGWEgcfmj_yuY0Q8EiWRt-g0rFw@mail.gmail.com>
	<CACRpkda5nYmAT3-fkxdYQEGpi6U=L-kphQEu3naoxPzO9a-7pQ@mail.gmail.com>
	<CAHdPZaPFtO1bRC3TdLx8MSgFMznr5FBXV5DdUyasNAcF34s3mQ@mail.gmail.com>
	<CACRpkdYB9wPuCH=U3V5EJAhj6Ob2HowUFYT7Q0nqtOYyf7asUQ@mail.gmail.com>
	<CAHdPZaPYbDSkeb__kESpoU46fheNuPHOA2uOhVDnyAyWZriHyQ@mail.gmail.com>
Date: Wed, 20 Jun 2012 09:52:06 +0200
Message-ID: <CACRpkdZAg8A2kms=mWvE6-HpMQcW_GskHze=4_Psn9_6zL7k9g@mail.gmail.com>
Subject: Re: Q: return of pinctrl_register and handing at drivers that use
 this function
From: Linus Walleij <linus.walleij@linaro.org>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 4:42 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
> On Mon, Jun 18, 2012 at 8:08 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Mon, Jun 18, 2012 at 2:04 PM, devendra.aaru <devendra.aaru@gmail.com> wrote:
>>
>>> So checking the return value of pinctrl_register with IS_ERR is not required.
>>
>> Nope.
>
> You mean to say that the check "IS_ERR(ret_ptr)" is not required? or
> the other way like its also needed.

I mean it shall be tested like this:

if (!pinmctrl_register(&foo)) {
    /* error case */
}

No IS_ERR() business.

Linus
