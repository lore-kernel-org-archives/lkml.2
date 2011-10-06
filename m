Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758201Ab1JFKK5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 06:10:57 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35911 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757058Ab1JFKK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 06:10:56 -0400
Date: Thu, 6 Oct 2011 11:05:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Adrian Bunk <bunk@stusta.de>
Cc: Arnaud Lacombe <lacombar@gmail.com>, Valdis.Kletnieks@vt.edu,
        "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Subject: Re: kernel.org status: establishing a PGP web of trust
Message-ID: <20111006110553.09d52b8c@lxorguk.ukuu.org.uk>
In-Reply-To: <20111005201904.GC14406@localhost.pp.htv.fi>
References: <201110020304.28288.rjw@sisk.pl>
	<4E87B885.50005@zytor.com>
	<201110021354.57995.rjw@sisk.pl>
	<4E88A537.4010008@zytor.com>
	<20111003093239.GB25136@localhost.pp.htv.fi>
	<y0mobxyjazi.fsf@fche.csb>
	<20111003180441.GD3072@localhost.pp.htv.fi>
	<34045.1317760188@turing-police.cc.vt.edu>
	<20111004223932.GA3460@localhost.pp.htv.fi>
	<CACqU3MWr5DKAWKydHmJuz=+a3UN3KdtsdXwfE-UxSD5_9tzqag@mail.gmail.com>
	<20111005201904.GC14406@localhost.pp.htv.fi>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.4; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When you add a Signed-off-by: to a patch you have to use your real name

Don't confuse real name and legal name. In particular remember

- Not all countries have a notion of legal name
- In many places 'real' and legal names are not particularly tied together
- Both legal and real names change but there is no kernel facility to
  update existing sign offs.
- Some cultures have multiple names for people as the norm
- A lot of signed off entries are transliterated (We don't have many
  signed off in Japanese or Chinese for example but mostly in
  transliterated form)
- The "official" transliterations vary by country, and no specific
  transliteration or indeed specific language is necessarily correct
- In many cases it is possible to change your "real" name to a nickname,
  (and indeed back again). Genuine UK names for official purposes include
  people like Mr Telephone Booth (changed his name for charity and kept
  it), and "Fruitbat".

So can I suggest we leave that quagmire for Google+ to sink into and
flounder and stay well out of it.

A key merely proves that the person who signed the object had access to
the key. A signed key merely proves that someone or indeed something with
access to the relevant key data signed it. Even in person signing proves
surprisingly little.  (Ob amusement - can one of a pair of identical
twins ever become a Debian developer)

It's an administrative convenience.

Signing patches is also only useful for tracing probable origin. It
doesn't prove they are any good. That's one reason I never signed any
security announcement when I was the CERT contact, it forced people to
check the announcement and advice made sense.

Alan
