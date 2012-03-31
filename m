Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753499Ab2CaVZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 17:25:06 -0400
Received: from mx2.netapp.com ([216.240.18.37]:21953 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752922Ab2CaVZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 17:25:02 -0400
X-IronPort-AV: E=Sophos;i="4.75,350,1330934400"; 
   d="scan'208";a="637740584"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Sasha Levin <levinsasha928@gmail.com>
CC: Chuck Lever <chuck.lever@oracle.com>, Jim Rees <rees@umich.edu>,
        "Lukas Razik" <linux@razik.name>, Pekka Enberg <penberg@kernel.org>,
        "Linux NFS Mailing List" <linux-nfs@vger.kernel.org>,
        LKML Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] nfs: Don't try mounting device as nfs root unless type
 fully matches
Thread-Topic: [PATCH] nfs: Don't try mounting device as nfs root unless type
 fully matches
Thread-Index: AczOyD8O2ia/X6JtQLKyxujV3UdWfRAxG/6AAAAyEYAAC/KdgAAAZ0QAAAAiuIA=
Date: Sat, 31 Mar 2012 21:24:53 +0000
Message-ID: <1333229105.2719.17.camel@lade.trondhjem.org>
References: <1325927523-30103-1-git-send-email-levinsasha928@gmail.com>
	 <5FF522E0-132E-4A6A-A40F-5CCD08AF800A@oracle.com>
	 <20120107181221.GA3777@umich.edu> <1326111265.30169.5.camel@lappy>
	 <CA+1xoqdQPi53GYr_Q6RtECJJcrz0TVVp4uNQX6jkfbQWQSNF7g@mail.gmail.com>
	 <D3642511-B29B-4CA7-A133-C99B711954C1@oracle.com>
	 <1333228179.2719.14.camel@lade.trondhjem.org>
	 <CA+1xoqfv82ngQ4oc5uozZQjN7PipWVjVu670-uUGC5o_3Nec9A@mail.gmail.com>
In-Reply-To: <CA+1xoqfv82ngQ4oc5uozZQjN7PipWVjVu670-uUGC5o_3Nec9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <C9504937551D3E459DEC9281F4283C70@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2VLPESR025607

On Sat, 2012-03-31 at 23:21 +0200, Sasha Levin wrote:
> On Sat, Mar 31, 2012 at 11:09 PM, Myklebust, Trond
> <Trond.Myklebust@netapp.com> wrote:
> > On Sat, 2012-03-31 at 11:27 -0400, Chuck Lever wrote:
> >> Oops.  Trond?  This got dropped somewhere.
> >
> > I don't own the 'init' directory, and since quite frankly this isn't
> > related to NFS at all, it should be sent to Linus directly.
> >
> > I'm quite happy to ack the patch if that would help.
> 
> The patch which has triggered this whole story (6829a048 ("NFS: Retry
> mounting NFSROOT")) modified init/ as well, and went in through the
> NFS tree. Can't this patch follow the same path?

No. It touches generic code unlike the above patch, which _only_ touches
NFS-related code.

> Anyhow, I've Cc'ed Linus in hopes that this patch can somehow find
> it's way into 3.4.

Don't just Cc: Linus on this thread: send the patch to him directly (and
Cc: linux-kernel@vger.kernel.org).

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
