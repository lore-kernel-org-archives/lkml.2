Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752103Ab2JRSq7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:46:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35038 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457Ab2JRSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:46:58 -0400
MIME-Version: 1.0
In-Reply-To: <871ugwny1n.fsf@rustcorp.com.au>
References: <CA+55aFwPaSB3a8XNxWMyKhwXVJtdOBO-o8-rz3O-vTbwv8K2Tg@mail.gmail.com>
 <87txtso9xw.fsf@rustcorp.com.au> <CA+55aFxZdtD51AVKLtKK95ooh8VB8-5Tt8nHsxSUT67CBRrp2g@mail.gmail.com>
 <871ugwny1n.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 18 Oct 2012 11:46:36 -0700
X-Google-Sender-Auth: Zh-u8V-R2sZAHJmZJMhGsp6Cttw
Message-ID: <CA+55aFwTz6xadNL37H6Qb8+rWNefn0cQ0URFPfD=Ea=J54xzGg@mail.gmail.com>
Subject: Re: RFC: sign the modules at install time
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: David Miller <davem@davemloft.net>, David Howells <dhowells@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 10:34 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> Hacking the keyid and signer-name to be extracted every time by
> sign-file takes my modules_install time from 18.6 seconds to 19.1.  We'd
> get that back easily by making sign-file a perl script anyway; it calls
> out to perl 3 times already.

Ok, that tiny slowdown seems worth the cleanup, especially if we'd get
it back from somebody re-writing it in perl.

Want to sign off on the two patches, or put them in your git tree?

                     Linus
