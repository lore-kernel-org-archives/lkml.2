Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab1ANP0t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 10:26:49 -0500
Received: from mail-ww0-f66.google.com ([74.125.82.66]:37117 "EHLO
	mail-ww0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab1ANP0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 10:26:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=iA4Q5WbQ+MfanBao9fEtu/LwYn3HPC4B/295uFBARp6PzaTL4/FFBN+SEoWW5v9fgu
         +WJimNa55UbV7V6VXo77xqGaP4DqQo6v+2kjmXztC6Em0tb2Es34CQJI9MXJTa2k2tyL
         2fc3qvI6SyhsKJ+dfVvIik0lnsFm38QGhPqwQ=
MIME-Version: 1.0
In-Reply-To: <201101141417.11817.hpj@urpla.net>
References: <8406.1294976295@jrobl>
	<AANLkTi=jozto+CNwfSKu2_dGWXaRi5p=3dqQngMz7g24@mail.gmail.com>
	<201101141417.11817.hpj@urpla.net>
Date: Sat, 15 Jan 2011 02:26:40 +1100
Message-ID: <AANLkTi=9wZ3XvnBd0_Vc2HxFdQ4xw+E0_bcwVB99i31_@mail.gmail.com>
Subject: Re: vfs-scale, keep the errno
From: Nick Piggin <npiggin@gmail.com>
To: Hans-Peter Jansen <hpj@urpla.net>
Cc: "J. R. Okajima" <hooanon05@yahoo.co.jp>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 15, 2011 at 12:17 AM, Hans-Peter Jansen <hpj@urpla.net> wrote:
> On Friday 14 January 2011, 05:01:37 Nick Piggin wrote:
>> On Fri, Jan 14, 2011 at 2:38 PM, J. R. Okajima <hooanon05@yahoo.co.jp>
> wrote:
>> > When open(2) without O_DIRECTORY opens an existing dir, it should
>> > return EISDIR. In do_last(), the variable 'error' is initialized
>> > EISDIR, but it is changed by d_revalidate() which returns any
>> > positive to represent 'the target dir is valid.'
>> > Should we keep and return the initialized 'error' in this case.
>>
>> Great, thank you very much. I just changed a few variable names but
>> applied it. Would you please add you Signed-off-by: on patches from
>> now on?
>>
>> Good reviewing work. Are you finding these by review or testing? I
>> think ltptests on an nfs mount should find this kind of bug... which
>> I should do.
>
> Nick, Junjiro is well known as a very smart (and|but) humble guy in the

I agree, based on the thoughtful review comments and patches :)

Thanks,
Nick
