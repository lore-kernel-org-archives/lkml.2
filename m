Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933117Ab2JSXGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 19:06:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53912 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759141Ab2JSXGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 19:06:53 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFyauaYYe=C1PAbhjHUECXSefPncv_COQ05J-zpF6-H7Zg@mail.gmail.com>
References: <20121019225140.31460.32873.stgit@warthog.procyon.org.uk> <CA+55aFyauaYYe=C1PAbhjHUECXSefPncv_COQ05J-zpF6-H7Zg@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Oct 2012 16:06:32 -0700
X-Google-Sender-Auth: Th-OfotuTWu5oE0h3t08JjAypEA
Message-ID: <CA+55aFy7QgEt_VU84aXZ_RY9C392C=B0Ewzd4GwZ44kQ5cGV3A@mail.gmail.com>
Subject: Re: [PATCH 1/2] MODSIGN: perlify sign-file and merge in x509keyid
 [ver #2]
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, davem@davemloft.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 3:58 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Also, I wonder how standard this /usr/bin/perl is:
>
>> +#!/usr/bin/perl -w

Well, we have other uses of that path in the kernel already, and your
v3 patch uses 'perl' in the Makefile to run it, so it will pick up the
path that way.

So I think it all looks fine now. Will apply, thanks,

             Linus
