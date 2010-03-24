Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab0CXM3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:29:17 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56506 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751500Ab0CXM3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:29:15 -0400
X-Sasl-enc: mrdzU766l0GQASrTAQnbulAKPoYMMYBHpYDiuGAz9LqH 1269433754
Message-ID: <4BAA0598.9000906@imap.cc>
Date: Wed, 24 Mar 2010 13:29:12 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.8) Gecko/20100205 SeaMonkey/2.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH] checkpatch: Add check for too short Kconfig descriptions
References: <20100320023216.GA917@basil.fritz.box> <4BA4CE32.1020207@imap.cc> <20100320140710.GS20695@one.firstfloor.org> <4BA504DD.2060107@imap.cc> <20100320180336.GT20695@one.firstfloor.org>
In-Reply-To: <20100320180336.GT20695@one.firstfloor.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----

Hash: SHA1



Am 2010-03-20 19:03 schrieb Andi Kleen:
> On Sat, Mar 20, 2010 at 06:24:45PM +0100, Tilman Schmidt wrote:
>> Am 2010-03-20 15:07 schrieb Andi Kleen:
>>> The warning merely is intended to get people to think
>>> about that. Yes it cannot enforce it directly.
>>
>> Then change the wording, at least. With the current wording, people will
>> think, "But I did!", and complain about a false positive on LKML, where
>> they will be annoyed to learn that checkpatch.pl's criterion for
>> "describing fully" is "having at least four lines".
> 
> Change to what?  If you have a better suggestion I can change it.

My suggestion:

- -+			WARN("please write a paragraph that describes the config symbol fully\n" . $herecurr) if ($length < 4);
++			WARN("Less than four lines of help text -- consider adding more detail\n" . $herecurr) if ($length < 4);

>>
>> I'm not thinking of circumvention, but of well-meaning authors writing
>> long explanations that describe everything the author found worth
>> mentioning, but still don't answer the essential question: "Should I
>> select that option?" In fact, most of the unhelpful Kconfig help texts
>> I've encountered where longer than four lines. :-)
> 
> I don't disagree that longer help texts can be unhelpful too,
> but at least there's some chance that they are. 
> 
> For a single sentence it's very unlikely ever that it's helpful.

We have to agree to disagree on that then, too.

Regards,
Tilman
-----BEGIN PGP SIGNATURE-----

Version: GnuPG v2.0.12 (MingW32)

Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/



iEYEARECAAYFAkuqBZgACgkQQ3+did9BuFtgjwCgim0E0xnYJEnbCJsvKflkaSdk

ITQAn2zjFpo4ODhhpDvgJGMIaUWJnLgZ

=SMok

-----END PGP SIGNATURE-----

