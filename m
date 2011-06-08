Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751989Ab1FHFHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:07:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:40873 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048Ab1FHFHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:07:04 -0400
Message-ID: <4DEF0375.4080108@kernel.org>
Date: Tue, 07 Jun 2011 22:07:01 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: users@kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
CC: "FTPAdmin Kernel.org" <ftpadmin@kernel.org>
Subject: [KORG] IPv6 Now enabled
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 07 Jun 2011 22:07:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Evening everyone,

Just thought I'd give a quick heads up to everyone that I just flipped
DNS so that we are now IPv6 enabled.  For the most part this is going to
be a frontend facing change, as OSUOSL does not currently have IPv6.

Services affected:
	- ns
	- geons
	- pub
	- mirrors
	- archive
	- git
	- mirrors.git
	- android.git
	- boot
	- lanana
	- linuxeda

Things of note *NOT* affected:
	- master / hera
	- any of the dynamic web stuff
	- vger

This is pretty close to one of the single biggest changes we've had at
kernel.org in a long time.  I've been fairly cautious about the
roll-out, but considering that our dns weighs in currently at about 2K
lines and 331K, but if I've missed something please drop a line to
ftpadmin@kernel.org, stop by #kernel.org on freenode or #korg on
LinuxNet or just generally get ahold of us and let us know.

The general hope is that we can leave this in place going forward, and
reporting anything amiss sooner rather than later would be good.

If anyone is interested, I'll probably be doing up a write-up on the
whole thing, with additional commentary, if your interested drop me a
line and I'll let you know when it's up.

- - John 'Warthog9' Hawley
Chief Kernel.org Administrator
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk3vA3EACgkQ/E3kyWU9die9VACeI3KVCRnSXY/808YkSYmkiZtG
LlgAniApyDu6VOkSw1rrMD5u35SPlkzA
=+ylX
-----END PGP SIGNATURE-----
