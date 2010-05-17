Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab0EQKNT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 06:13:19 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:47964 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab0EQKNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 06:13:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eIKDNltez8fy48RegCEBzUR4+4dRi6jq9mi3pxbfvjL7b3VrTMhMQDo2uJCZBYltMK
         d8e6DzOttw1pDDKatcrH4ZAKTjDEefo8rZPojLPTDvoDFKhoP9hpUT0MO0snBQiNe/t3
         yNRSvGvZFmp8QKdf554sGu5qpFFR3FGZ8hnlc=
MIME-Version: 1.0
In-Reply-To: <AANLkTik2OcSBGdkRQKFl6xh06PEr7Al6xaUsmMGGC6jo@mail.gmail.com>
References: <AANLkTikD7M_PKH3YgOWIvrcD6aW6X-gYIo2iw52QRRq_@mail.gmail.com>
	 <20100517160319.A195.A69D9226@jp.fujitsu.com>
	 <AANLkTik2OcSBGdkRQKFl6xh06PEr7Al6xaUsmMGGC6jo@mail.gmail.com>
Date: Mon, 17 May 2010 15:43:17 +0530
Message-ID: <AANLkTilGLJJG_eLHaqvJ5jOzxp96SbOroTCbHe9g5TXE@mail.gmail.com>
Subject: Re: Which function returns LWP in Linux.
From: Srinivas Nayak <sinu.nayak2001@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> You are asking procps question in LKML.
>

Dear Jaswinder,

I am new to linux mailing lists. Thought, this process id related
question can only be answered by linux kernel developers, as they may be
working with this almost everyday. And more to this, I searched in the
Internet for LWP id, but found no positive answer. Many places gettid
was the answer, but it doesn't work.

I apologize, if lkml is not the best place to ask programming related
questions. It would be kind, if you let me know the correct mailing
list where general linux programming discussions happen. To my find,
linux-c-programming mailing list is not so active.

After some more research, i foind that

syscall(SYS_gettid)

returns LWP id. Isn't this correct?

Sincerely,
Srinivas Nayak
