Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2JNULo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 16:11:44 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:48293 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab2JNULm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 16:11:42 -0400
MIME-Version: 1.0
In-Reply-To: <87fw5m7ipz.fsf@rustcorp.com.au>
References: <87fw5m7ipz.fsf@rustcorp.com.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 14 Oct 2012 13:11:20 -0700
X-Google-Sender-Auth: 15mJdtgaCrwNOzlZzpvEOOk6COA
Message-ID: <CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com>
Subject: Re: [PULL] modules
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: LKML <linux-kernel@vger.kernel.org>, Alex Lyashkov <umka@cloudlinux.com>,
        Arnd Bergmann <arnd@arndb.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        David Howells <dhowells@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Josh Boyer <jwboyer@redhat.com>, linux-crypto@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Milan Broz <mbroz@redhat.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Randy Dunlap <rdunlap@xenotime.net>, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 10, 2012 at 2:57 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>
> ----------------------------------------------------------------
> module signing is the highlight, but it's an all-over David Howells frenzy...
>
> ----------------------------------------------------------------

Hmm. What happened here? It *looks* from your pull request like you
had a tag, and you usually do, but there's no tag anywhere..

I've pulled and resolved the branch, and I'm going through it now, but
I'd like this verified before I push out if it all looks fine..

          Linus
