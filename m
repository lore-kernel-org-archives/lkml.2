Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab2C2EJG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 00:09:06 -0400
Received: from mx2.netapp.com ([216.240.18.37]:24005 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab2C2EJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 00:09:01 -0400
X-IronPort-AV: E=Sophos;i="4.75,335,1330934400"; 
   d="scan'208";a="637079260"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Boaz Harrosh <bharrosh@panasas.com>,
        Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        Linux Kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Please pull NFS client bugfixes for Linux 3.4...
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes for Linux 3.4...
Thread-Index: AQHNDU+E6ZdFWqFeI0qI10V6oguVYJaA+9eAgAAAowCAAAM+AIAAAjSAgAANwwCAAAd4AIAABtYA
Date: Thu, 29 Mar 2012 04:08:39 +0000
Message-ID: <1332994124.30608.5.camel@lade.trondhjem.org>
References: <1332986348.19172.43.camel@lade.trondhjem.org>
	 <CA+55aFwVzhgsw005P3+BkLw_=noJwkQB3G=Q4GqhfLL1WyPHfg@mail.gmail.com>
	 <1332986928.19172.45.camel@lade.trondhjem.org>
	 <CA+55aFyQ0r5mN9=3DUVENCtdj8VMLRjiXTc5Xd4o+F=s9B8xMg@mail.gmail.com>
	 <1332988097.19172.51.camel@lade.trondhjem.org>
	 <4F73D44C.5090604@panasas.com>
	 <CA+55aFyHmQBXw3ik3qv81_3Zp+4r-VUt_TNBs-M19b6Zt7PDeQ@mail.gmail.com>
In-Reply-To: <CA+55aFyHmQBXw3ik3qv81_3Zp+4r-VUt_TNBs-M19b6Zt7PDeQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <576D737F29148C4B9BD368E93DC9C684@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2T49Pae002628

On Wed, 2012-03-28 at 20:44 -0700, Linus Torvalds wrote:
> On Wed, Mar 28, 2012 at 8:17 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> >
> > Thank you Trond for sharing, here is a new user
> 
> Oh, *please* use git pull-request instead. It does a lot of things
> much better, including the diffstat/shortlog and the tag message, none
> of which Trond's does.
> 
>                       Linus

Maybe I'm running an older version of git (Fedora 16 latest update), but
when I do

git request-pull v3.3 git://git.linux-nfs.org/projects/trondmy/linux-nfs.git nfs-for-3.4-1

I get:

                The following changes since commit c16fa4f2ad19908a47c63d8fa436a1178438c7e7:
                
                  Linux 3.3 (2012-03-18 16:15:34 -0700)
                
                are available in the git repository at:
                  git://git.linux-nfs.org/projects/trondmy/linux-nfs.git ..BRANCH.NOT.VERIFIED..
                
                Andy Adamson (4):
                      SUNRPC: add sending,pending queue and max slot to xprt stats
                      NFSv4.1 set highest_used_slotid to NFS4_NO_SLOT
                      NFSv4.1 handle DS stateid errors
                      NFSv4.1 cleanup DS stateid error handling
                
                ....
                lots of shortlog stuff followed by the diffstat.
                ....

and that's all...


I'm pretty sure that a request to pull from "..BRANCH.NOT.VERIFIED.."
would piss you off, which is why I'll stick to my script for now. It
already has a '-s' option to give you the shortlog, and it will give you
the diffstat by default. All it is missing is the tag message...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
