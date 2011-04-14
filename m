Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab1DNOnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 10:43:25 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:55639 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758881Ab1DNOnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 10:43:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=VkToSnIy/F/hR1wOYVA5mOu2kmhwHZHSh7SVMPzFqU9ZfTOD7dpkaaJUzWkRxnNdbE
         kgyvy/oHIKOmRb7PRkG0Jhih9tqIVfw3Vc5pF4Wq5xXEfE72iMNgTFDMd/qbc/m/1z6V
         Y79cHvOOu4b6yJ0ll9gaBvUCThMGxxRb5C8HU=
MIME-Version: 1.0
In-Reply-To: <201104132150.05623.richard@nod.at>
References: <201104132150.05623.richard@nod.at>
Date: Thu, 14 Apr 2011 21:43:23 +0700
Message-ID: <BANLkTinj1vtMk4qo-dc46KWXScjDDt4vCg@mail.gmail.com>
Subject: Re: gcc-4.6.0 generates no code for sub_preempt_count()
From: masterkom masterkom <masterkom33@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,, I have the project to make Operating System using linux kernel.
That system is multiplatform, which is combine linux and window . This
project hope All people that who has familiar with windows can use
this operating system without sin. This project is free..

I hape there people can help us to done this project ,, thx,,,

On 4/14/11, Richard Weinberger <richard@nod.at> wrote:
> Hi,
>
> I'm facing a very strange issue with gcc-4.6.0 and UML.
> Within __local_bh_enable() gcc generates no code for sub_preempt_count().
>
> See:
> http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc460.txt
> vs.
> http://userweb.kernel.org/~rw/uml-gcc460/__local_bh_enable-gcc431.txt
>
> Interestingly it generates code for add_preempt_count().
> I can reproduce this on x86 and x86_64.
>
> The problem has to do with UML's current_thread_info() function.
> When I replace it with arch/x86's (unportable) variant gcc generates code.
>
> Any ideas whether this is a gcc or a kernel issue?
> Thanks,
> //richard
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
