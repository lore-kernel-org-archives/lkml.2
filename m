Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab0JORq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 13:46:59 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:40422 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab0JORq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 13:46:58 -0400
/m: 
From: Richard Weinberger <richard@nod.at>
To: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
Date: Fri, 15 Oct 2010 19:46:53 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.25.20-0.7-pae; KDE/4.4.4; i686; ; )
References: <201010131328.06465.toralf.foerster@gmx.de> <201010151133.38170.toralf.foerster@gmx.de>
In-Reply-To: <201010151133.38170.toralf.foerster@gmx.de>
Cc: user-mode-linux-devel@lists.sourceforge.net,
        Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151946.53402.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Can you please post more details.
What exactly causes the crash?
phpsysinfo does a lot of stuff.
On my test bed it works fine.

Am Freitag 15 Oktober 2010, 11:33:37 schrieben Sie:
> Hello,
> 
> git bisect gave :
> 
> tfoerste@n22 ~/devel/linux-2.6 $ git bisect bad
> 365b18189789bfa1acd9939e6312b8a4b4577b28 is the first bad commit
> commit 365b18189789bfa1acd9939e6312b8a4b4577b28
> Author: Christoph Hellwig <hch@lst.de>
> Date:   Wed Jul 7 18:53:25 2010 +0200
> 
>     add f_flags to struct statfs(64)
> 
>     Add a flags field to help glibc implementing statvfs(3) efficiently.
> 
>     We copy the flag values from glibc, and add a new ST_VALID flag to
>     denote that f_flags is implemented.
> 
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> :040000 040000 92f04bf96f0c6bb2df3ddea83a4a27c35985bdcc
> 
> e702d8dd95a3897e085bf3fe4919e2dd30a57b47 M      arch
> 
> :040000 040000 5705bba0e9a2a61112281f7bb1a1030ef9eb337e
> 
> 34fc3ea912581ae7923a15246291387bfc354e47 M      fs
> 
> :040000 040000 578a5bb0743aa85adfec7a25f82d440b2ea4db27
> 
> 7e96f95b6f1d6ccc9e004b560670638db66b8a93 M      include
> 
> 
> BTW is UML dead ?
> (I'm asking b/c there're so many different issues - compile errors or the
> UML kernel crashes during start or during shutdown, independent of the
> result of the wget issue I was investigating - there are 120 skip'ed
> commits within the git bisect log beside 46 good and 15 bad commits and I
> didn't saw any chance to fully automate the bisect)

Hmm, I did a lot git bisects on UML 2.6.35 to 2.6.36.
2.6.36-rc1 does not always compile. You need no apply f3c072a first.
I've not seen any crashes during bootup nor shutdown. Can you provide some 
more details?

Thanks,
//richard
