Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756393Ab2GaTAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 15:00:40 -0400
Received: from mx2.netapp.com ([216.240.18.37]:38359 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753083Ab2GaTAi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 15:00:38 -0400
X-IronPort-AV: E=Sophos;i="4.77,688,1336374000"; 
   d="scan'208";a="670560888"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Mel Gorman <mgorman@suse.de>, Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: linux-next: manual merge of the akpm tree with the nfs tree
Thread-Topic: linux-next: manual merge of the akpm tree with the nfs tree
Thread-Index: AQHNbtR4a/OwVO3zl0Gi+NGAKMKYSZdDp5EAgABEHACAAAvMAIAABFUAgAAlywCAAA8bAIAABIGA
Date: Tue, 31 Jul 2012 19:00:35 +0000
Message-ID: <1343761233.5528.27.camel@lade.trondhjem.org>
References: <20120731142441.0d01100f9d050ec6e479c923@canb.auug.org.au>
	 <20120731103336.GN612@suse.de> <1343745442.519.20.camel@lade.trondhjem.org>
	 <20120731151936.GR612@suse.de>
	 <1343748906.5528.17.camel@lade.trondhjem.org>
	 <20120731175022.GU612@suse.de>
	 <20120731114426.029644e0.akpm@linux-foundation.org>
In-Reply-To: <20120731114426.029644e0.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <D19DA7C956281D4096902162AA82FE3B@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id q6VJ0j5m012898

On Tue, 2012-07-31 at 11:44 -0700, Andrew Morton wrote:
> On Tue, 31 Jul 2012 18:50:22 +0100
> Mel Gorman <mgorman@suse.de> wrote:
> 
> > Stephen Rothwell reported a merge conflict between a MM patch "nfs:
> > enable swap on NFS" and an NFS patch "nfs: skip commit in
> > releasepage if we're freeing memory for fs-related reasons".
> 
> grumble.  This happened becase new stuff was added to -next right in
> the middle of the merge window.  Please don't dothat.
> 
Normally, I would have added it when Jeff asked me to, but I've been on
vacation for 2 weeks, and this is a bugfix that needs to go into
stable...

Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
