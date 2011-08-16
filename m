Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1HPXaB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 19:30:01 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:45110 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab1HPXaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 19:30:00 -0400
Message-ID: <4E4AFCFC.9020008@kernel.org>
Date: Tue, 16 Aug 2011 16:27:56 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: [KORG] Taking hera down to deal with the load issues
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 16 Aug 2011 16:27:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hey Everyone,

Ok so since I'm back from vacation, and things don't seem to be getting
better, I'm going to take hera/master offline in about 30 minutes or so
(5pm PDT or Tue Aug 17 0:0:0 UTC 2011).  This is going to involve a base
OS upgrade, and a full on new kernel.

This should get the loads back into what we are expecting, and give me a
chance to more thoroughly investigate the panics from last week.  If
you've got questions or comments, please give me a shout as soon as
possible.

- - John 'Warthog9' Hawley
Chief Kernel.org Administrator
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk5K/PkACgkQ/E3kyWU9dieV8wCcCUmHmIYqeqK0eBUt7f3ne07J
994An3MrErlAjOLx/zkpB6T1dNsHVLtC
=CSPj
-----END PGP SIGNATURE-----
