Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab2JNVXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 17:23:55 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38894 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751611Ab2JNVXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 17:23:52 -0400
Date: Sun, 14 Oct 2012 22:27:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>,
        Alex Lyashkov <umka@cloudlinux.com>, Arnd Bergmann <arnd@arndb.com>,
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
Subject: Re: [PULL] modules
Message-ID: <20121014222754.0f11b609@pyramind.ukuu.org.uk>
In-Reply-To: <CA+55aFyVcTT4tKTVvhzXz3t4uw=MDLU00NAAOacWt6i3xovERg@mail.gmail.com>
References: <87fw5m7ipz.fsf@rustcorp.com.au>
	<CA+55aFyGuy8P4Uaanmv7DncjsN6cvQxvWrrMKKnF=67J+BkshQ@mail.gmail.com>
	<CA+55aFyVcTT4tKTVvhzXz3t4uw=MDLU00NAAOacWt6i3xovERg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I realize that fips_enabled is only for crazy people, but it's exactly
> code like this that limits it to only crazy people. Is there some
> *reason* for this?

Presumably its so a typical server with reboot on panic will reboot so
the attacker can hide the attempt better ;-)

Alan

