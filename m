Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751571Ab1KDXpe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 19:45:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:33246 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1KDXpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 19:45:32 -0400
MIME-Version: 1.0
In-Reply-To: <7vaa8bbni3.fsf@alter.siamese.dyndns.org>
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike>
 <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
 <1320049150.8283.19.camel@dabdike> <CA+55aFz3=cbciRfTYodNhdEetXYxTARGTfpP9GL9RZK222XmKQ@mail.gmail.com>
 <7vy5w1ow90.fsf@alter.siamese.dyndns.org> <CA+55aFwL_s=DcT46dprcYVWEAm_=WkuTV6K9dAn3wc_bDQU8vA@mail.gmail.com>
 <7vwrbjlj5r.fsf@alter.siamese.dyndns.org> <CA+55aFx_rAA6TJkZn1Zvu6u9UjxnmTVt0HpMnvaE_q9Sx-jzPg@mail.gmail.com>
 <7vk47jld5s.fsf@alter.siamese.dyndns.org> <CA+55aFz7TeQQH3D4Tpp31cZYZoQKeK37jouo+2Kh61Wa07knfw@mail.gmail.com>
 <CAJo=hJv5nAKH_ptYSWfMvFQv0Dj+naPXK35wSzKYkfPOYsWkxg@mail.gmail.com>
 <CA+55aFx0oCd6-sh0psYxho-s=sHAK0RHXJHfLewRuUcdXzxZbg@mail.gmail.com>
 <CA+55aFwXu=+HdQ5nW11Ts5p-V=KgpxjyagKqB+Xv+qBOEEWXvQ@mail.gmail.com>
 <7v62j1gitn.fsf@alter.siamese.dyndns.org> <7vaa8bbni3.fsf@alter.siamese.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Nov 2011 16:45:10 -0700
X-Google-Sender-Auth: -26sgQiDAIENEaQe6XvPA3jATh8
Message-ID: <CA+55aFzCuEG7ZpSJ5BLFF3Rfe1Tqjr82fUwFGJTqMvzB=fbVcA@mail.gmail.com>
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

On Fri, Nov 4, 2011 at 2:12 PM, Junio C Hamano <gitster@pobox.com> wrote:
>
> If we really wanted to go this route, the attached single-liner should be
> sufficient for the DWIMmery.

My first reaction on reading the patch was "maybe it would be safer to
put the tags case after 'branches', so that the behavior in the
presense of ambiguity would stay the same as with the old case", but
thinking it through I think it's more important to be consistent with
the other lookups, which all prefer tags over branches when ambiguous.

So Ack, patch looks sane to me, and clearly makes it easier to fetch
tags individually.

                  Linus
