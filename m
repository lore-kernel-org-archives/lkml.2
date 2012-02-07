Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab2BGNWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:22:30 -0500
Received: from mx2.netapp.com ([216.240.18.37]:10871 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab2BGNWR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:22:17 -0500
X-IronPort-AV: E=Sophos;i="4.73,377,1325491200"; 
   d="scan'208";a="623201875"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        Pavel Emelianov <xemul@parallels.com>, "neilb@suse.de" <neilb@suse.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>,
        "bfields@fieldses.org" <bfields@fieldses.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 00/11] SUNRPC: make sysctl per network namespcase context
Thread-Topic: [PATCH 00/11] SUNRPC: make sysctl per network namespcase
 context
Thread-Index: Acy6TW2k7hxsK5OWRJm2xAc6uU6kaQrg3EcAAANmOgA=
Date: Tue, 7 Feb 2012 13:21:34 +0000
Message-ID: <1328620894.3126.2.camel@lade.trondhjem.org>
References: <20111214103602.3991.20990.stgit@localhost6.localdomain6>
	 <4F310E8E.5040608@parallels.com>
In-Reply-To: <4F310E8E.5040608@parallels.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <E03EDC82AF5DD140ADFC6207CA6E7C10@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 07 Feb 2012 13:21:40.0639 (UTC) FILETIME=[6D7B4AF0:01CCE59B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q17DMgZC028311

On Tue, 2012-02-07 at 15:44 +0400, Stanislav Kinsbursky wrote:
> Trond, what are your plans about this patch set?
> Are you waiting for me and Eric to reach some decision, that suits both of us?

Yes. I'd like a consensus on the solution.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
