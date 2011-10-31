Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934742Ab1JaWvL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:51:11 -0400
Received: from b-pb-sasl-quonix.pobox.com ([208.72.237.35]:40745 "EHLO
	smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934617Ab1JaWvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:51:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=jWDGtNYAv40uto2AMXYngYNAe45CuFTa
	D4GTmoX/TuvxT8qONffuceHLD578uH+PTbI3erLOaIcu4v2Wf+TZssh/6U+rjcCQ
	dbX1gFW2Fljd5uLZbIO1x0wDpmaLL4oDquB9r1kquCeKHo+4fBGXA8P4u5Ju6GFI
	Y0FhZ7FAfAw=
From: Junio C Hamano <gitster@pobox.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org>
 <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike>
 <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org>
 <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <4EAF1F40.3030907@zytor.com>
 <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com>
 <4EAF2245.90308@zytor.com>
 <CA+55aFzedaAzzWfzhqVf8y8ZW0jeb56hZwdV3UodSp8Q_Qhc2A@mail.gmail.com>
Date: Mon, 31 Oct 2011 15:51:06 -0700
In-Reply-To: <CA+55aFzedaAzzWfzhqVf8y8ZW0jeb56hZwdV3UodSp8Q_Qhc2A@mail.gmail.com> (Linus
 Torvalds's message of "Mon, 31 Oct 2011 15:38:54 -0700")
Message-ID: <7vvcr4ojvp.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Pobox-Relay-ID: D1ED15A0-0412-11E1-B2A8-9DB42E706CDE-77302942!b-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> But seriously, I don't care about the *implementation* all that much.
> If people want to use the crazy git "notes" capability, you can do
> that too, although quite frankly, I don't see the point.

As I already said, I do not think notes is a good match as a tool to do
this.

> matters is that "git push" and "git pull" would JustWork(tm), and
> check the signature if one exists, without having to cut-and-paste
> data that simply shouldn't be visible to the user.
>
> I abhor the interface Ingo suggested, for example....

Some cut-and-paste (or piping the e-mail to a command) would be necessary
evil, though, as you would have GPG keys from more than one trusted person
in your keyring, and when you are responding to a pull-request from person
A, finding a valid commit signed by person B should not be a success, but
at least should raise a warning.
