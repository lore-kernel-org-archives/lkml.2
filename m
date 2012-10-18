Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753997Ab2JRDTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 23:19:22 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:36779 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753968Ab2JRDTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 23:19:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxo-b3nUAWhG0N7hJkH1goStvBBTCT7XWGD+RJLG0=fsQ@mail.gmail.com>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <3179.1350512382@warthog.procyon.org.uk> <CA+55aFzEH1jguw8NB90si2uxvyO63FuKPOc8wiEPRCYwruSzRg@mail.gmail.com>
 <20121018005432.GA20163@kroah.com> <CA+55aFxo-b3nUAWhG0N7hJkH1goStvBBTCT7XWGD+RJLG0=fsQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 17 Oct 2012 20:18:59 -0700
X-Google-Sender-Auth: Z_idmMK5RqhCYSYcwkBxiZQqD0I
Message-ID: <CA+55aFx_qv7P1_XU7eiKZFz4A-F7VkdJtKs2vGy2a7xGXg9OFg@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Greg KH <gregkh@linuxfoundation.org>
Cc: David Howells <dhowells@redhat.com>, David Miller <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        jwboyer@redhat.com, pjones@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 8:14 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Oh, yes, we should make sure the key file gets cleaned up at "make clean".

Ooh, double-checked.

Actually, we have documented "make clean" to leave around "enough
build support to build external modules".

So technically, I guess what we do right now is correct: you have to
do "make distclean" (or "mrproper") to clean the key files.

Now, whether we should perhaps change that (and change the
documentation), I dunno.

            Linus
