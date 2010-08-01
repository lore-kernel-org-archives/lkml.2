Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab0HANjT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 09:39:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53426 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701Ab0HANjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 09:39:17 -0400
Message-ID: <4C5579E9.2030200@ontolinux.com>
Date: Sun, 01 Aug 2010 15:43:05 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.1.11) Gecko/20100711 Thunderbird/3.0.6
MIME-Version: 1.0
To: Glenn D <doiggl@velocitynet.com.au>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        linux reiserfs-devel <reiserfs-devel@vger.kernel.org>
Subject: Re: Formal Reiser4 inclusion and todo list?
References: <alpine.DEB.2.01.0904181302440.6162@bogon.housecafe.de> <49EB1E3F.1020905@gmail.com> <542E227E-E31D-496C-93FB-19393133297F@MailNewsRSS.com> <200904250153.33258.volkerarmin@googlemail.com> <2E9381E6-A09A-4330-9A61-C4B7D7CE0E71@MailNewsRSS.com> <49F2CF9A.1060202@inn.nl> <49F2D43F.90105@ontolab.com> <8c113a260904250416n28fbdacs682ef8e6859b7dbf@mail.gmail.com> <49F339A2.9080705@ontolab.com> <200904252027.n3PKReMx073755@mail.meer.net> <49F393A1.4030004@gmail.com> <0d42c3ebde41a3d0bcc01f9fccc07f1c@mail.velocitynet.com.au> <4C508BFC.3010008@ontolinux.com>
In-Reply-To: <4C508BFC.3010008@ontolinux.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:BB9rU0NFx9XXBd4nXfQdvUngH8ULA6ZuWZv9bikLjkz
 YVcyJGfmHc3NVfpmolBCithY/mb1lfySHZy9WiUokOD9NLALBn
 IVNHMv524sfw4wHuMhjqKyjJEe9q6M2v/b2lgcoomH1U+wum6Y
 /koQa2zFtYBgJ2t4DKtTAFLhvsQJcmM6Xo1Z7mmwhJANR5tNIn
 ci9Pn21R4Ew+Nxm0460RA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Glenn;

On the 28.07.2010 21:58, I wrote:
> Aloha Glenn;
>
> At the 28.07.2010 17:21, you (doiggl@velocitynet.com.au) wrote:
>>> The following items are still unaddressed:
>>>
>>> 1. running igrab() in the writepage() path is really going to hammer
>>>     inode_lock.  Something else will need to be done here.
>>>
>>> 2. Running iput() in entd() is a bit surprising.  iirc there are 
>>> various
>>> ways
>>>     in which this can recur into the filesystem, perform I/O, etc.  I
>>> guess it
>>>     works..
>>>     But again, it will hammer inode_lock.
>>>
>>> 3. the writeout logic in entd_flush() is interesting (as in "holy 
>>> cow").
>>>     It's very central and really needs some good comments describing
>> what's
>>>     going on in there - what problems are being solved, which decisions
>> were
>>>     taken and why, etc.
>>>
>>> 4. reiser4_wait_page_writeback() needs commenting.
>>>
>>> 5. reading the comment in txnmgr.c regarding MAP_SHARED pages: a number
>> of
>>>     things have changed since then.  We have page-becoming-writeable
>>>     notifications and probably soon we'll always take a pagefault 
>>> when a
>>>     MAP_SHARED page transitions from pte-clean to pte-dirty (although I
>>> wouldn't
>>>     recommend that a filesystem rely upon the latter for a while yet).
>>>
>>> Feel free to address them.
>>>
>>> Thanks,
>>> Edward.
>> Has the number of items reduced at all ?
>> just curious
>> Cheers Glenn
>
> I haven't looked at the code since several years. But as far as I have 
> followed the development, all of the patch sets since then (April 
> 2009) were only of cosmetical nature, or said with other words, to 
> keep it coping with changes at different positions, like eg. VFS.
> And in a handful of blogs I got no additional/other informations, 
> despite that the maintainer is working at a company in the field of 
> another file system since the end of last year, so that he has only 
> few time for Reiser FSs, and also that the opinions are that the 
> project is dead.
>

We also found out that, like the ReiserFS maintainer, the starter of 
this thread, who is also the starter and maintainer of the ReiserFS wiki 
as well as the filler of the ReiserFS wiki with copyrighted materials, 
has changed to the development of the Btrfs file system, too. For 
example in June he made a patch with:

-	tristate "Btrfs filesystem (EXPERIMENTAL) Unstable disk format"
-	depends on EXPERIMENTAL
+	tristate "Btrfs filesystem"

so that "Btrfs is highly experimental" could be substituted with "Btrfs 
is under heavy development".

Again, this gives something to think about the engagement of the person, 
as well. We always had the impression that he, like a handful of other 
persons, was only here at reiserfs to mess up the R4 development, to 
work and make politics against this project, and to disturb the 
developers and their businesses.
Btw.: In the case of copying copyrighted materials into the ReiserFS 
wiki the kernel.org administrator was already informed by us, but 
explained that it's up to [Hans Reiser] to ask for removing these 
materials from kernel.org, which is an argumentation we are unable to 
understand, because the kernel.org administrator does know that 
copyrighted materials are illegally publicated on the kernel.org website.

Cheerio
Christian *<:o)   O>-<   -(D)>-<
