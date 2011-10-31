Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934049Ab1JaVqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:46:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39869 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab1JaVqo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:46:44 -0400
Message-ID: <4EAF1731.2070908@zytor.com>
Date: Mon, 31 Oct 2011 14:46:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jeff Garzik <jeff@garzik.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git patches] libata updates, GPG signed (but see admin notes)
References: <20111026202235.GA20928@havoc.gtf.org> <1319969101.5215.20.camel@dabdike> <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
In-Reply-To: <CA+55aFx1NGWfNJAKDTvZfsHDDKiEtS4t4RydSgHurBeyGPyhXg@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2011 10:12 AM, Linus Torvalds wrote:
> 
> Actually, I have been running "gpg --verify" on the email that use the
> standard PGP encapsulation (ie the kind that Jeff used, that has
> "-----BEGIN PGP SIGNED MESSAGE-----" in it.
> 
> It's the rfc3516-type email (aka protocol="application/pgp-encrypted")
> type that I can't even verify, because that's not something that gpg
> knows inherently how to check: you have to decode the message the
> right way and know what the rules are, and I have no intention of
> trying to figure it out. I have yet to find any usable tool that is
> able to check it, and I'm certainly not going to waste time trying to
> parse the rfc and write my own.
> 

What client are you using (or are you using the gmail web interface?)

	-hpa

