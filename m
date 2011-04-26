Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab1DZUd2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:33:28 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60248 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757868Ab1DZUdZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:33:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=Zkf5UZB/6ciNg4S/5xk/9BPQr9nt3P5XLKLeKUsOGm74hSkOx5IGUqm2AOAXQFA0Ax
         tHC/OJproD/swbYkTwQA7VhLM2KEdy/bAma2EHFtTfJAzBjVa7CWQCr0A4Ngi6coFvff
         6grLvhIDNK95P8y/v+Qq0pNoTeiNJfW4ybpeI=
MIME-Version: 1.0
In-Reply-To: <1303849650.2232.41.camel@offworld>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	<1303849650.2232.41.camel@offworld>
Date: Tue, 26 Apr 2011 17:33:24 -0300
Message-ID: <BANLkTi=57Q-w2iXeYjdvr4-ZzSkWCRKhSg@mail.gmail.com>
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Thiago Farina <tfransosi@gmail.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 5:27 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> On Tue, 2011-04-26 at 15:49 -0300, Thiago Farina wrote:
>> This macro is arguably more readable than its variants:
>> - !strcmp(a, b)
>> - strcmp(a, b) == 0
>
> Anyone how is going to be reading kernel C code, can understand strcmp I
> think.
>
We all know that, but please see the previous discussion.

http://www.spinics.net/lists/kernel/msg1176975.html
http://www.spinics.net/lists/kernel/msg1176977.html

Best regards,

> Cheers,
> Davidlohr
>
>
