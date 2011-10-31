Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934765Ab1JaWwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 18:52:50 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37240 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934723Ab1JaWws (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 18:52:48 -0400
MIME-Version: 1.0
In-Reply-To: <7vzkggok6u.fsf@alter.siamese.dyndns.org>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <4EAF1F40.3030907@zytor.com> <CA+55aFxprv9JR4gtt_UDXheHR5G8PrUA3-Mj0CPsU6E5EzNYeg@mail.gmail.com>
 <4EAF2245.90308@zytor.com> <7vzkggok6u.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 31 Oct 2011 15:52:26 -0700
X-Google-Sender-Auth: oaiCNg1GKrSGGCYtI5s9YyRj-Fg
Message-ID: <CA+55aFwnVZ-mK3FChvFn778Z-cT107f4v-h0CDmwkP88=Z9aHA@mail.gmail.com>
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

On Mon, Oct 31, 2011 at 3:44 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> So nobody is worried about this (quoting from my earlier message)?

No, because you haven't been reading what we write.

The tag is useless.

The information *in* the tag is not. But it shouldn't be saved in the
tag (or note, or whatever). Because that's just an annoying place for
it to be, with no upside.

Save it in the commit we generate. BAM! Useful, readable, permanent,
and independently verifiable.

And the advantage is that we can make that same mechanism add
"maintainer notes" to the merge message too. Right now some
maintainers write good notes about what the merge will bring in, but
they are basically lost, because git is so good at merging and doesn't
even stop to ask people to edit the merge message.

                    Linus
