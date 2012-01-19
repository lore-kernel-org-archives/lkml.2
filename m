Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932319Ab2ASPeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 10:34:06 -0500
Received: from mx2.netapp.com ([216.240.18.37]:18451 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753248Ab2ASPeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 10:34:04 -0500
X-IronPort-AV: E=Sophos;i="4.71,536,1320652800"; 
   d="scan'208";a="618392512"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Subject: RE: [PATCH 0/5] SUNRPC: make caches network namespace aware
Date: Thu, 19 Jan 2012 07:34:02 -0800
Message-ID: <2E1EB2CF9ED1CB4AA966F0EB76EAB4430CE01EE4@SACMVEXC2-PRD.hq.netapp.com>
In-Reply-To: <4F18376C.9090504@parallels.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 0/5] SUNRPC: make caches network namespace aware
Thread-Index: AczWv43uXoXSXhe6Ru+XqfioxgVU7gAABeOQ
References: <20120119144517.9957.59143.stgit@localhost6.localdomain6> <1326986392.6114.1.camel@lade.trondhjem.org> <4F18376C.9090504@parallels.com>
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: "Stanislav Kinsbursky" <skinsbursky@parallels.com>
Cc: "Dr James Bruce Fields" <bfields@redhat.com>, <linux-nfs@vger.kernel.org>,
        "Pavel Emelianov" <xemul@parallels.com>, <neilb@suse.de>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "James Bottomley" <jbottomley@parallels.com>, <bfields@fieldses.org>,
        <davem@davemloft.net>, <devel@openvz.org>
X-OriginalArrivalTime: 19 Jan 2012 15:34:03.0832 (UTC) FILETIME=[C6251B80:01CCD6BF]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0JFYBlx031767

> -----Original Message-----
> From: Stanislav Kinsbursky [mailto:skinsbursky@parallels.com]
> Sent: Thursday, January 19, 2012 10:32 AM
> To: Myklebust, Trond
> Cc: Dr James Bruce Fields; linux-nfs@vger.kernel.org; Pavel Emelianov;
> neilb@suse.de; netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> James Bottomley; bfields@fieldses.org; davem@davemloft.net;
> devel@openvz.org
> Subject: Re: [PATCH 0/5] SUNRPC: make caches network namespace aware
> 
> 19.01.2012 19:19, Trond Myklebust Ğ¿Ğ¸ÑˆĞµÑ‚:
> > On Thu, 2012-01-19 at 18:48 +0400, Stanislav Kinsbursky wrote:
> >> One more step towards to "NFS in container".
> >> With this patch set caches are allocated per network namespace.
> >>
> >> The following series consists of:
> >>
> >> ---
> >>
> >> Stanislav Kinsbursky (5):
> >>        SUNRPC: cache creation and destruction routines introduced
> >>        SUNRPC: create unix gid cache per network namespace
> >>        SUNRPC: create GSS auth cache per network namespace
> >>        SUNRPC: ip map cache per network namespace cleanup
> >>        SUNRPC: generic cache register routines removed
> >
> > The patches look good, and I've applied them for now in my 'devel'
> > branch so we can test them, but I'd like to get an Ack/Nack from Bruce
> > before committing to merging them.
> >
> 
> Cool, thanks.
> BTW, these patches depends on patch "NFSd: use network-namespace-
> aware cache registering routines", which Bruce took already (and it's even in
> linux-next already), but not in your devel tree for some reason.

In that case, would it make more sense to carry them in Bruce's tree?

--
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
