Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664Ab2A3UuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 15:50:15 -0500
Received: from mx2.netapp.com ([216.240.18.37]:50793 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588Ab2A3UuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 15:50:13 -0500
X-IronPort-AV: E=Sophos;i="4.71,592,1320652800"; 
   d="scan'208";a="620951254"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: Stanislav Kinsbursky <skinsbursky@parallels.com>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "xemul@parallels.com" <xemul@parallels.com>,
        "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jbottomley@parallels.com" <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 1/2] SUNRPC: register RPC stats /proc entries in passed
 network namespace context
Thread-Topic: [PATCH 1/2] SUNRPC: register RPC stats /proc entries in passed
 network namespace context
Thread-Index: AQHM330mvIzN1M7DUUCYKy+itm99J5Yl6IoA
Date: Mon, 30 Jan 2012 20:49:49 +0000
Message-ID: <1327956588.4090.26.camel@lade.trondhjem.org>
References: <20111206123748.15702.93290.stgit@localhost6.localdomain6>
	 <20111206124240.15702.61866.stgit@localhost6.localdomain6>
	 <CAP=VYLoTsFvqez72mLEctmrcHbf0VcfREbHF32zsnh35=RUsHQ@mail.gmail.com>
In-Reply-To: <CAP=VYLoTsFvqez72mLEctmrcHbf0VcfREbHF32zsnh35=RUsHQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <090A94A2A88E8141BDE183D145AD566E@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 30 Jan 2012 20:49:51.0493 (UTC) FILETIME=[B65FFB50:01CCDF90]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q0UKoNms005973

On Mon, 2012-01-30 at 13:29 -0500, Paul Gortmaker wrote:
> On Tue, Dec 6, 2011 at 8:42 AM, Stanislav Kinsbursky
> <skinsbursky@parallels.com> wrote:
> > This patch makes it possible to create NFS program entry ("/proc/net/rpc/nfs")
> > in passed network namespace context instead of hard-coded "init_net".
> 
> Hi Trond,
> 
> Is this patch going to be dropped and re-submitted?   It has obvious
> typos that have been causing reported build failures[1] in linux-next
> for a week now.   In addition to that, it has several whitespace errors
> (long lines, no space after comma, etc.) that I bet checkpatch.pl
> would have found, if it was used.
> 
> Commit 4494c750240bab1bb83bd8f4d5a268663c37c9b3 in next-20120130.

I've applied Randy's fix to my tree. Sorry it took so long, but I was
travelling last week...

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
