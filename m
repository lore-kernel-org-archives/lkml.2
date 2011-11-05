Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753795Ab1KEQlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Nov 2011 12:41:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47118 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753253Ab1KEQlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Nov 2011 12:41:47 -0400
MIME-Version: 1.0
In-Reply-To: <7v1utn9it8.fsf@alter.siamese.dyndns.org>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org> <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org> <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <7v62j1gitn.fsf@alter.siamese.dyndns.org> <7vvcr1f38j.fsf@alter.siamese.dyndns.org>
 <CA+55aFyRawm9CoJMiEXDFCX4YTidPOiV4oqSS2d7nNv7Ecw8BQ@mail.gmail.com> <7v1utn9it8.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 5 Nov 2011 09:41:25 -0700
X-Google-Sender-Auth: NoPk9upjCNs8bgTtoNjIOeuIdYA
Message-ID: <CA+55aFy0gA0ROSyE03h6Lw0zn4B4j-oEFBmffOcWs6NfyYy8JA@mail.gmail.com>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
To: Junio C Hamano <gitster@pobox.com>
Cc: "Ted Ts'o" <tytso@mit.edu>, Shawn Pearce <spearce@spearce.org>,
        git@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 4, 2011 at 11:36 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> About the ugliness of the merge commit log messages, you have already
> learned to ignore them with "log --no-merges" ;-)

Absolutely not. I look at merges all the time. I never use
"--no-merges" except when I'm doing certain statistics (ie "How many
real changes do we have") or when I do release files.

But I actually think it's important that people write *good* merge
messages. I've berated some people for it when they just have

    Merge branch 'origin'

in their commit message, because I think a merge commit should say why
it happened or what it brought in.

> and the material the
> patch series I sent out adds are at the end, so "/^commit.*$" in less
> would hopefully work well enough in "log --no-merges" as well.

I agree that being at the end helps, but I do a lot of "git log
ORIG_HEAD.." etc, and I don't do a lot of "/^commit" searching.

The "/commit" thing I do tends to be because I do "git log -p" to see
patches, but at the same time am not going to read through
everything..

So I'd really like some way to not see it.

Ted suggested a NUL character in the commit message in front of the
"hidden content". What do you think?

                Linus
