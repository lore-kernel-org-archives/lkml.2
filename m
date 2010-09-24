Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757678Ab0IXVMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 17:12:39 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:55410 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756557Ab0IXVMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 17:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=AurzlP7XnGmbytILMuBhpQbEJglnJDb5yqwR3KWfJBWlB+AW2QLOM2Y7PoF96zflP9
         e/fMyC5ugYG/gxlpJN+PRueBqUwtjXfcvdhEkKmyHB535TrPEEytztPDFX8ee5L7rVEl
         3onfE4ae71mNacjB/uTfR6SpyK4/wes8wxl8o=
MIME-Version: 1.0
In-Reply-To: <20100924205108.GA8191@haskell.muteddisk.com>
References: <AANLkTikqf4rn6BP2gyQAuQrvt7EdFY8yfa+o8nfR9xWE@mail.gmail.com>
	<AANLkTikvGGz+33ni=Kov1qM1DpSj2WVuk89u=TwE9iL_@mail.gmail.com>
	<AANLkTin1YfwwVcDNUBsi34iYC6HA5Y6+uOFZN=+Q2hqs@mail.gmail.com>
	<20100924205108.GA8191@haskell.muteddisk.com>
Date: Fri, 24 Sep 2010 17:12:37 -0400
Message-ID: <AANLkTimoQr4W8XQ0ATCP2BY7cJnvLfTafuqPDheqZA5w@mail.gmail.com>
Subject: Re: [PATCH 00/21] Staging: cleaned up makefiles cflag lines
From: T Dent <tdent48227@gmail.com>
To: T Dent <tdent48227@gmail.com>, matt mooney <mfmooney@gmail.com>,
        greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/10, matt mooney <mfm@muteddisk.com> wrote:
> On 16:39 Fri 24 Sep     , T Dent wrote:
>> On 9/24/10, matt mooney <mfmooney@gmail.com> wrote:
>> > On Fri, Sep 24, 2010 at 11:25 AM, T Dent <tdent48227@gmail.com> wrote:
>> >> I changed every makefile in the staging directory to use the proper
>> >> ccflags-y option instead of EXTRA_CFLAGS. It builds also :) .
>> >
>> > Um, you didn't do a lot of these right. Maybe you should look into why
>> > the change was made in the first place. For semantic reasons, I was
>> > also changing the first assignment to ":=" from "+=".
>>
>> I can resend them with the a small modification to the patch files if you
>> want.
>
> After looking at more of them, my "a lot" was a little bit of an
> overstatement. The first few I randomly looked at happen to use the
> incorrect
> pattern, but most are simple without relying on a variable. Yeah, I think
> you
> should resubmit with a "[PATCH v2]." The pattern is:
>
> ifeq ($(FOO),y)
>      EXTRA_CFLAGS := <flags>
> endif
>
> changes to:
>
> ccflags-$(FOO) := <flags>
>
> Also, the rest of the kernel tree has been done except drivers/media;
> however, I
> am going to email them in a little bit asking if some consolidation is
> possible
> due to every driver there relying on a few flags. So thanks for the help
> (though
> is was a good thing I was saving staging for last)!
>
> -mfm
>
>

Okay i'll resubmit the patches when I edit it how you said.

Thanks,
Tracey
