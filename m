Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932634Ab1EFTs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 15:48:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:44523 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755371Ab1EFTs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 15:48:26 -0400
Message-ID: <4DC4507E.1060407@suse.com>
Date: Fri, 06 May 2011 15:48:14 -0400
From: Jeff Mahoney <jeffm@suse.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@google.com>
Subject: Re: [PATCH] softlockup: re-increase hung tasks check from 2 minutes
 to 8 minutes
References: <4DC4153E.5020304@suse.com> <20110506191814.GE7151@elte.hu>
In-Reply-To: <20110506191814.GE7151@elte.hu>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 05/06/2011 03:18 PM, Ingo Molnar wrote:
> 
> * Jeff Mahoney <jeffm@suse.com> wrote:
> 
>>  Commit e162b39a, which moved the soft lockup code around a bit,
>>  accidentally reverted commit fb822db4, which extended the soft lockup
>>  timeout from 2 minutes to 8 minutes.
>>
>>  This patch restores it to 8 minutes.
> 
> This patch wont apply, because i already have your other patch committed. Could 
> you do it against latest -tip:
> 
>   http://people.redhat.com/mingo/tip.git/README

After Andrew commented, and I agreed, that the sysctl should just be set
instead of adding another config option I was thinking we'd just drop
the other patch and replace it with this one.

- -Jeff

- -- 
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk3EUH4ACgkQLPWxlyuTD7JL8ACfS1DnnFGjN0j3zwt1eldfk5pu
e20AoInzD0SzxeTH4F1kNKZHHExt9eO+
=qV/f
-----END PGP SIGNATURE-----
