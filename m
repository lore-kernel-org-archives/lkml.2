Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab1FMK1F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 06:27:05 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36950 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab1FMK1B convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 06:27:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=EICBvLxfnLhgpITyNtz4bPz2k6m3zt8/+lHMgaCic69FNOjHEBMPENuU8qPiBSar09
         SWH5kNFI2ARE6ZY7w7ZVeTkN7+vJfwV8STKVeZ/0drw/DzISIVSsCo2fzpRWe+ukteAc
         SZ//N9BEdBDgOKJt8NaHr6WzJuuLZ4Z6ufIX4=
MIME-Version: 1.0
In-Reply-To: <20110613100713.GA30962@elte.hu>
References: <20110609172744.333794089@goodmis.org>
	<20110609172910.425793191@goodmis.org>
	<20110613100713.GA30962@elte.hu>
Date: Mon, 13 Jun 2011 13:27:00 +0300
X-Google-Sender-Auth: puxOMK0I0_1xWsGw6Ps8RANN0Kw
Message-ID: <BANLkTi=0ckkC0SXhE9xKsh4hx-pzYh3hPw@mail.gmail.com>
Subject: Re: [PATCH 01/15] tracing: Schedule a delayed work to call wakeup()
From: Pekka Enberg <penberg@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Ingo Molnar <mingo@redhat.com>, Michael Rubin <mrubin@google.com>,
        David Sharp <dhsharp@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 1:07 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> +     const unsigned long delay = msecs_to_jiffies(2); //delay 2 ms
>
> We don't do C++ comments in the kernel ...

Heh, we also don't do pointless comments like the one above! ;-)
