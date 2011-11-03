Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1KCCZm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:25:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34136 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab1KCCZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 22:25:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAJo=hJsXvSyB65KBp8sfciT=h5uZSqSUdxkpWtZJRtr4hXAh5A@mail.gmail.com>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org> <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org> <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com> <CAJo=hJsXvSyB65KBp8sfciT=h5uZSqSUdxkpWtZJRtr4hXAh5A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 2 Nov 2011 19:25:17 -0700
X-Google-Sender-Auth: 7lEjX3zEHVLR9PNLKdu6kPGjbRw
Message-ID: <CA+55aFyXg32mko8TOGCfGHpr3jHBEgcKiK7HdVwq0Wez0fAs9A@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: Shawn Pearce <spearce@spearce.org>
Cc: Junio C Hamano <gitster@pobox.com>, git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 7:14 PM, Shawn Pearce <spearce@spearce.org> wrote:
>
> So you propose we put the tag contents into the merge commit message
> so it can be verified after the fact? So merges are now going to be
> something much more horrific to read, because it will end with Git
> object tag cruft, the tag message, and the PGP signature spew that no
> human can decode in the head?

Actually, I wanted to just drop the damn thing.

To me, the point of the tag is so that the person doing the merge can
verify that he merges something trusted.

However, everybody else seems to disagree, and wants that stupid
signature to live along in the repository. And I can live with that,
although I do agree with you that it's not exactly pretty. I can live
with "ugly signature that I don't care for" way more than "stupid
design".

Because unlike your crazy empty commit, it at least fits the workflow,
and it certainly isn't any uglier that extraneous pointless commit.

You can disagree. You obviously do. I simply don't care. Because I'm right.

(And your claim that it's big UI fixes and protocol changes is pure
and utter garbage. I just sent a patch that cleans the code up,
removes a line that improperly drops information and gets rid of the
biggest problem with our current handling of tags. No protocol changes
involved, no big UI fixup).

                        Linus
