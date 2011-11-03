Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab1KCDY0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 23:24:26 -0400
Received: from oker.escape.de ([194.120.234.254]:34689 "EHLO oker.escape.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932193Ab1KCDYZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 23:24:25 -0400
Date: Thu, 3 Nov 2011 04:22:05 +0100
From: Jochen Striepe <jochen@tolot.escape.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shawn Pearce <spearce@spearce.org>, Junio C Hamano <gitster@pobox.com>,
        git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
Message-ID: <20111103032205.GA25888@pompeji.miese-zwerge.org>
References: <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org>
 <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org>
 <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <CAJo=hJsXvSyB65KBp8sfciT=h5uZSqSUdxkpWtZJRtr4hXAh5A@mail.gmail.com>
 <CA+55aFyXg32mko8TOGCfGHpr3jHBEgcKiK7HdVwq0Wez0fAs9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyXg32mko8TOGCfGHpr3jHBEgcKiK7HdVwq0Wez0fAs9A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

	Hi,

On Wed, Nov 02, 2011 at 07:25:17PM -0700, Linus Torvalds wrote:
> To me, the point of the tag is so that the person doing the merge can
> verify that he merges something trusted.
> 
> However, everybody else seems to disagree, and wants that stupid
> signature to live along in the repository.

It seems quite useless and leading to false conclusions in several cases
where the merger's gpg output differs from someone's checking later on,
e.g. when

 - the signing key has been revoked in the mean time (for whatever
   reasons)
 - the signing key has expired
 - the public part of the signing key is not available for the general
   public.

AFAIK gpg just gives you an error code and a message like e.g. "Key has
expired" without stating if the key was valid _when signing the commit_.

How do you plan to handle this when keeping the signature in the
repository? Or am I overlooking something?


Thanks,
Jochen.
