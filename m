Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab1KVSFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:05:35 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47848 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751355Ab1KVSFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:05:34 -0500
Date: Tue, 22 Nov 2011 18:05:20 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Josh Boyer <jwboyer@gmail.com>, Randy Dunlap <rdunlap@xenotime.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.2-rc1
Message-ID: <20111122180520.2c0c3e0f@pyx>
In-Reply-To: <4ECAFDAD.5040801@panasas.com>
References: <CA+55aFzytqbGcOzWvYAo-EnJCeK5mFqdCF5OjMTeM5UBfeyCXw@mail.gmail.com>
	<4EBAB5F7.80000@xenotime.net>
	<CA+5PVA6tBx4i1XZ+AF=uaOsjYCshG9CzXHWjnJcsJ=z1qw1F4A@mail.gmail.com>
	<4ECAFDAD.5040801@panasas.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; i386-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> My god that totally-brain-dead Fedora Kernel rpm generation.

It's designed to produce kernel packages for distribution. It is indeed
useless for much else.

> I wish there was a strait forward way to point to a Kernel
> git tree HEAD and say "make rpm", which is simply the tar
> of the "make modules_install" and the "make install" output
> + a simple script to manipulate grub.conf

That's what the upstream make rpm tries to achieve. If it's not working
right on Fedora then we should fix it to work around any Fedora brokenness

> Not today's Fedora-Kernel git tree which is not a Linux
> git tree at all but those patches above + stable.
> Any simple tree moments needs to involve black patch magic
> and fear of hell. (Don't try this at home)

Fedora is now getting so weird and dependant on magic initrds it's become
pretty unusable for kernel development work nowdays IMHO because it's
undebuggable.

However "make rpm" from the Linus tree is meant to be as far as possible
generic.

Alan
