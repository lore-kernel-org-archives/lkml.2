Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab0CTRYs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 13:24:48 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:43014 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751923Ab0CTRYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 13:24:47 -0400
X-Sasl-enc: 7ARSNVgXFvtXrgr+p3M2G7j6DqbBmkyoeJ3ExmV9LLbC 1269105886
Message-ID: <4BA504DD.2060107@imap.cc>
Date: Sat, 20 Mar 2010 18:24:45 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.8) Gecko/20100205 SeaMonkey/2.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH] checkpatch: Add check for too short Kconfig descriptions
References: <20100320023216.GA917@basil.fritz.box> <4BA4CE32.1020207@imap.cc> <20100320140710.GS20695@one.firstfloor.org>
In-Reply-To: <20100320140710.GS20695@one.firstfloor.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 2010-03-20 15:07 schrieb Andi Kleen:
> The warning merely is intended to get people to think
> about that. Yes it cannot enforce it directly.

Then change the wording, at least. With the current wording, people will
think, "But I did!", and complain about a false positive on LKML, where
they will be annoyed to learn that checkpatch.pl's criterion for
"describing fully" is "having at least four lines".

But even with a better wording, I think the warning will still do more
harm than good.

> Yes it's not a perfect measure and can be circumvented. But hopefully
> most users would not.

I'm not thinking of circumvention, but of well-meaning authors writing
long explanations that describe everything the author found worth
mentioning, but still don't answer the essential question: "Should I
select that option?" In fact, most of the unhelpful Kconfig help texts
I've encountered where longer than four lines. :-)

Thanks,
Tilman
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkulBN0ACgkQQ3+did9BuFtg4QCeNBnPAbMg3+dYfoimlG5/lQZ/
vRYAniohcXcoeC3+59eKSWwZ3B4fJ6Ix
=E5sA
-----END PGP SIGNATURE-----
