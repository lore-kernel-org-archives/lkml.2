Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796Ab1JaW47 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:56:59 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59691 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934704Ab1JaW45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:56:57 -0400
MIME-Version: 1.0
In-Reply-To: <7vvcr4ojvp.fsf@alter.siamese.dyndns.org>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <4EAF1F40.3030907@zytor.com> <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com>
 <4EAF2245.90308@zytor.com> <CA+55aFzedaAzzWfzhqVf8y8ZW0jeb56hZwdV3UodSp8Q_Qhc2A@mail.gmail.com>
 <7vvcr4ojvp.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 15:56:35 -0700
X-Google-Sender-Auth: ttY3rzU154frN_-764RPAb-6eOo
Message-ID: <CA+55aFyKWLUMQFfaeKJKGFPV_7kfOGjf+pSZ1Y8afzkT4OYQ9Q@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: Junio C Hamano <gitster@pobox.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 31, 2011 at 3:51 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> Some cut-and-paste (or piping the e-mail to a command) would be necessary
> evil, though, as you would have GPG keys from more than one trusted person
> in your keyring, and when you are responding to a pull-request from person
> A, finding a valid commit signed by person B should not be a success, but
> at least should raise a warning.

Why?

The signer of the message needs to be printed out *anyway*. I can
match that up with the pull request, the same way I already match up
diffstat information.

So any extra cut-and-paste is (a) stupid, (b) unnecessary and (c) annoying.

It's also "bad user interface". The whole point is that we should make
the user interface *good*. Which means that the pushing side should
only need to add a "-s" to ask for signing, have to type his
passphrase (and even that would go away when using gpg-agent or
something), and perhaps a message (which would not be about the
signing, but about something that could be added to the merge commit.

And the receiving side would just do the "git pull" and automatically
just get notified that "Yes, this push has been signed by key Xyz
Abcdef"

                     Linus
