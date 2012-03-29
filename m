Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2C2CI7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 22:08:59 -0400
Received: from mx2.netapp.com ([216.240.18.37]:56568 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641Ab2C2CIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 22:08:52 -0400
X-IronPort-AV: E=Sophos;i="4.75,335,1330934400"; 
   d="scan'208";a="637063897"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux NFS mailing list <linux-nfs@vger.kernel.org>,
        "Linux Kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Please pull NFS client bugfixes for Linux 3.4...
Thread-Topic: [GIT PULL] Please pull NFS client bugfixes for Linux 3.4...
Thread-Index: AQHNDU+E6ZdFWqFeI0qI10V6oguVYJaA+9eAgAAAowA=
Date: Thu, 29 Mar 2012 02:08:44 +0000
Message-ID: <1332986928.19172.45.camel@lade.trondhjem.org>
References: <1332986348.19172.43.camel@lade.trondhjem.org>
	 <CA+55aFwVzhgsw005P3+BkLw_=noJwkQB3G=Q4GqhfLL1WyPHfg@mail.gmail.com>
In-Reply-To: <CA+55aFwVzhgsw005P3+BkLw_=noJwkQB3G=Q4GqhfLL1WyPHfg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <AE1421D6C64F754388B1A0EDF73396B1@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2T292F5002089

On Wed, 2012-03-28 at 19:06 -0700, Linus Torvalds wrote:
> On Wed, Mar 28, 2012 at 6:59 PM, Myklebust, Trond
> <Trond.Myklebust@netapp.com> wrote:
> >
> > Please pull from the signed tag "nfs-for-3.4-2" in the repository at
> >
> >   git pull git://git.linux-nfs.org/projects/trondmy/linux-nfs.git tag nfs-for-3.4-2
> 
> Btw, please change your pull request to say "tag/nfs-for-3.4-2"
> instead of "tag nfs-for-3.4-2".
> 
> Both work, but there's a subtle difference: the "pull tag xyz" is
> basically asking me to not just pull, but also add the tag to my set
> of tags, which I'm not interested in. In contrast "pull tag/xyz" asks
> me to just pull the tag contents.

Sure thing... I wasn't aware of that semantic difference, but I'm quite
happy to add it to my script...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
