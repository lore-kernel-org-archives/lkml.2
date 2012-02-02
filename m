Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757379Ab2BBTtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:49:41 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59074 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753639Ab2BBTtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:49:40 -0500
X-Sasl-enc: 4oGN4gonhpYhq7eyNOwSH7Wr0/kxEEo4DmkOzCvHNKE9 1328212179
Message-ID: <4F2AE8D2.2090000@fastmail.fm>
Date: Thu, 02 Feb 2012 19:49:38 +0000
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: markh@compro.net
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: git question
References: <4F2AE6E9.5090402@compro.net>
In-Reply-To: <4F2AE6E9.5090402@compro.net>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/02/12 19:41, Mark Hounschell wrote:
> It's been a while but this used to work.
> 
> # git clone 
> git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-allstable.git
>
> 
Cloning into linux-2.6-allstable...
> fatal: The remote end hung up unexpectedly
> 
> Google showed nothing helpful? Where do I go. I need to bisect
> from 2.6.38 to 2.6.39
> 

That repo has been deleted. The full list is available at:

git.kernel.org

If you want to bisect 2.6.38 -> 2.6.39 then I sugest you try :

git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Which is Linus' official repo. If you want to bisect from 2.6.38.x ->
something else then you will have to try the stable repo, I think the
following will help:

git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git

The only thing to be careful of is that 2.6.39.x is not a direct
decendant of 2.6.38.x, but it is a direct decentant of 2.6.38: the
stable trees have patches added in parallel.

Hope this helps,

Jack
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iJwEAQECAAYFAk8q6M4ACgkQNmg8QyarTdKLdQP/dyQ8TJVNTPwU5mcQiDP+GtIs
lhDlBCDqMRLgpIRz3Wrju/nJQQILv2lUbIGrCpXNT59F12UOTLbMDE6MDNXt8x+j
Vk8BKZhKcu4sNWXWvSVkqMLWBVhk1wPQkgw0mveaiGvf5DLV7WQunD9hwmSF05lf
gvJGkTTHew13IUv8j5E=
=B7MR
-----END PGP SIGNATURE-----
