Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751959Ab1HQIGG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 04:06:06 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:53797 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751647Ab1HQIF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 04:05:58 -0400
Message-ID: <4E4B7664.9070301@kernel.org>
Date: Wed, 17 Aug 2011 01:05:56 -0700
From: "J.H." <warthog9@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] [KORG] Taking hera down to deal with the load
 issues
References: <4E4AFCFC.9020008@kernel.org>
In-Reply-To: <4E4AFCFC.9020008@kernel.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 17 Aug 2011 01:05:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sorry about the delay, the upgrade took longer than expected and the
initial kernel didn't actually solve the load issue completely.  I've
since installed a very slightly modified build of the initial kernel and
had to reboot hera twice more (both to the same kernel, but I again ran
`lsof -p <pid>` and had Linux panic on me.  A feature that has very
consistently bitten me on a number of kernels and a number of systems
lately).

This second kernel is at least, so far, acting a lot closer to what I'd
expect from hera, but the disk cache is still filling.  I'm going to
keep an eye on it for a bit longer tonight.  As a note, the only
difference between the first 3.1-rc1 kernel and the second, that is
currently running, was the explicit disabling of IMA and recompiling the
kernel.

I'm going to give the all clear at this point, I won't be doing any more
reboots without an additional e-mail and notice.  If you see any
problems or issue, or you catch that the loads are spiking up into the
stratosphere, please let me know.

- - John 'Warthog9' Hawley

On 08/16/2011 04:27 PM, J.H. wrote:
> Hey Everyone,
> 
> Ok so since I'm back from vacation, and things don't seem to be getting
> better, I'm going to take hera/master offline in about 30 minutes or so
> (5pm PDT or Tue Aug 17 0:0:0 UTC 2011).  This is going to involve a base
> OS upgrade, and a full on new kernel.
> 
> This should get the loads back into what we are expecting, and give me a
> chance to more thoroughly investigate the panics from last week.  If
> you've got questions or comments, please give me a shout as soon as
> possible.
> 
> - John 'Warthog9' Hawley
> Chief Kernel.org Administrator

_______________________________________________
Users mailing list
Users@linux.kernel.org
http://linux.kernel.org/mailman/listinfo/users
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk5LdmQACgkQ/E3kyWU9dic7rgCcDuBBmmfmNeyqs/zC1t9cByzy
5J0AnRcfO4701ix0HAr+KVmNKVedl38O
=FQPl
-----END PGP SIGNATURE-----
