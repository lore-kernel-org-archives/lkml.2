Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760295Ab2D0Oub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 10:50:31 -0400
Received: from mx2.netapp.com ([216.240.18.37]:22402 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760020Ab2D0Ou3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 10:50:29 -0400
X-IronPort-AV: E=Sophos;i="4.75,491,1330934400"; 
   d="scan'208";a="643860505"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Josh Boyer <jwboyer@redhat.com>
CC: Jim Rees <rees@umich.edu>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] NFSv4: Add modalias for "nfs4"
Thread-Topic: [PATCH] NFSv4: Add modalias for "nfs4"
Thread-Index: AQHNJHcmB5tVtvMMXUiGbvC5SkV+epavLeAAgAAINQCAAACBAA==
Date: Fri, 27 Apr 2012 14:50:28 +0000
Message-ID: <1335538228.3910.1.camel@lade.trondhjem.org>
References: <20120427131031.GA13189@zod.bos.redhat.com>
	 <20120427141918.GA15506@umich.edu>
	 <20120427144840.GB13189@zod.bos.redhat.com>
In-Reply-To: <20120427144840.GB13189@zod.bos.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E63E257AB343AF48BC41454E291160A4@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3REocc7022395

On Fri, 2012-04-27 at 10:48 -0400, Josh Boyer wrote:
> On Fri, Apr 27, 2012 at 10:19:18AM -0400, Jim Rees wrote:
> > Josh Boyer wrote:
> > 
> >   When NFSv4 is configured, the support goes into the nfs.ko module.
> >   However, nfs-utils seems to pass "nfs4" as the fileststem type for
> >   NFSv4 mounts.
> > 
> > Weren't we going to change that to nfs and use nfsvers to select nfs4?
> 
> I have, approximately, no idea.  At least the version of nfs-utils found
> in Fedora 17 and rawhide, it's still using "nfs4".   I believe that is
> nfs-utils-1.2.6-rc6 based.

nfs4 is still _supported_ in Fedora 17, rawhide and upstream as a legacy
feature, but the recommended practice should be to mount -t nfs -overs=4
(or -overs=4.1).

Cheers
  Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
