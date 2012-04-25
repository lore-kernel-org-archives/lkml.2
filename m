Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2DYEJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 00:09:18 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:49399 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab2DYEJQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 00:09:16 -0400
MIME-Version: 1.0
In-Reply-To: <4F9777FB.8050109@msgid.tls.msk.ru>
References: <4F94222C.6080608@msgid.tls.msk.ru> <1335172741.2226.10.camel@perseus.themaw.net>
 <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru>
 <4F959A5A.8070907@msgid.tls.msk.ru> <CA+55aFyQ4y9jyRXyejKwtf3yXJX52hQkLuwJ5=jfQM+yLkBNMw@mail.gmail.com>
 <4F96D0E7.9060000@msgid.tls.msk.ru> <CA+55aFw=cfYZO7PWDRRuZw1nYxvUk-63qfVVwfdJWevtmZoOig@mail.gmail.com>
 <1335300159.1393.13.camel@localhost.localdomain> <CA+55aFx9hATsnANWYSoagycc2HnXO=5Oa3gtqBjMr9eoe1obpA@mail.gmail.com>
 <4F9777FB.8050109@msgid.tls.msk.ru>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 24 Apr 2012 21:08:54 -0700
X-Google-Sender-Auth: G_uEAtjSrFaAnZG1BdvRZSx0jA4
Message-ID: <CA+55aFyhTj2TjQ46ewruKXGF=x0ng2HAOfMDSC96WH3UTt=B5Q@mail.gmail.com>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit environment
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Thomas Meyer <thomas@m3y3r.de>, Ian Kent <raven@themaw.net>,
        "stable@kernel.org" <stable@kernel.org>, autofs@vger.kernel.org,
        Linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 9:05 PM, Michael Tokarev <mjt@tls.msk.ru> wrote:
>
> How about something like
>
>     sbi->compat_daemon = is_compat_task() && strcmp(task->comm, "automount") != 0
>
> instead?  (This task->comm is a pseudocode, just to show the idea, I don't
> know where this info can be found in kernel)

Thomas, does that work for you?

                Linus
