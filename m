Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab0CTNbd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:31:33 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50097 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751006Ab0CTNbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:31:31 -0400
X-Sasl-enc: CQKX5o7Mq5okqWJAozPJG/slrR1vetyzoo3lohgCADRE 1269091891
Message-ID: <4BA4CE32.1020207@imap.cc>
Date: Sat, 20 Mar 2010 14:31:30 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.1.8) Gecko/20100205 SeaMonkey/2.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH] checkpatch: Add check for too short Kconfig descriptions
References: <20100320023216.GA917@basil.fritz.box>
In-Reply-To: <20100320023216.GA917@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 2010-03-20 03:32 schrieb Andi Kleen:
>     I've seen various new Kconfigs with rather unhelpful one liner
>     descriptions. Add a Kconfig warning for a minimum length of the
>     Kconfig help section.

I don't think helpfulness can be enforced via line count.
A one-liner can be quite sufficient (eg. CRYPTO_MD4).
OTOH more lines can still leave important questions unanswered (eg.
CRYPTO_SALSA20_586 whose help text is identical to that of
CRYPTO_SALSA20, leaving you wondering when to choose one over the other).

Jm2c
Tilman

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkukzjIACgkQQ3+did9BuFvE1wCff7n2x/bAbiZrJkTnQrEUi7eI
oVsAoJO6l5JMBddFfQOwQDetun1tCtEx
=qkDo
-----END PGP SIGNATURE-----
