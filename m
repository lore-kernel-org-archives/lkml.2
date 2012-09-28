Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2I1IAm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:00:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab2I1IAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:00:41 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAMuHMdVGfKEeGwwf-B1rukhhdXWBYfBp2MiYbHe09P6RHkUbyw@mail.gmail.com>
References: <CAMuHMdVGfKEeGwwf-B1rukhhdXWBYfBp2MiYbHe09P6RHkUbyw@mail.gmail.com> <5555.1348531649@warthog.procyon.org.uk> <87ehlp30pd.fsf@rustcorp.com.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: dhowells@redhat.com, Rusty Russell <rusty@rustcorp.com.au>,
        herbert@gondor.hengli.com.au, pjones@redhat.com, jwboyer@redhat.com,
        linux-crypto@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, keyrings@linux-nfs.org
Subject: Re: [GIT PULL] Asymmetric keys and module signing
Date: Fri, 28 Sep 2012 09:00:27 +0100
Message-ID: <27146.1348819227@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> Just wondering, what's the advantage of doing panic over just
> rejecting the module?
> Panic is a DoS?

FIPS mode is strange like that.

David
