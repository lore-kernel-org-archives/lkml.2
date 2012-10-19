Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776Ab2JSW7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:59:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61925 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758670Ab2JSW7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:59:18 -0400
MIME-Version: 1.0
In-Reply-To: <20121019225140.31460.32873.stgit@warthog.procyon.org.uk>
References: <20121019225140.31460.32873.stgit@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Oct 2012 15:58:57 -0700
X-Google-Sender-Auth: a1AUzfFgacFgnM7kO_3Od_I0XWw
Message-ID: <CA+55aFyauaYYe=C1PAbhjHUECXSefPncv_COQ05J-zpF6-H7Zg@mail.gmail.com>
Subject: Re: [PATCH 1/2] MODSIGN: perlify sign-file and merge in x509keyid
 [ver #2]
To: David Howells <dhowells@redhat.com>
Cc: rusty@rustcorp.com.au, davem@davemloft.net, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version still seems to have some debug turds in it:

On Fri, Oct 19, 2012 at 3:51 PM, David Howells <dhowells@redhat.com> wrote:
>
> +       printk("Check for sig\n");
> +
...
> +                       printk("Found sig\n");
...
> +#define DEBUG

Also, I wonder how standard this /usr/bin/perl is:

> +#!/usr/bin/perl -w

and maybe we should use Unix best practices and make it do

    #!/usr/bin/env perl

instead?

But I dunno, maybe /usr/bin/perl has become sufficiently standardized..

              Linus
