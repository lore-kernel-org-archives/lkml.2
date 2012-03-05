Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab2CEB6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:58:50 -0500
Received: from mx2.netapp.com ([216.240.18.37]:52278 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab2CEB6t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:58:49 -0500
X-IronPort-AV: E=Sophos;i="4.73,531,1325491200"; 
   d="scan'208";a="630665728"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the nfs tree
Thread-Topic: linux-next: build failure after merge of the nfs tree
Thread-Index: AQHM+nN4EJ3jwe8C/EOymHYoJruh8w==
Date: Mon, 5 Mar 2012 01:58:33 +0000
Message-ID: <1330912712.14357.15.camel@lade.trondhjem.org>
References: <20120305114513.547822059ca10e329c1bccb0@canb.auug.org.au>
In-Reply-To: <20120305114513.547822059ca10e329c1bccb0@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <03316338BC49C04BB98E646001873D6B@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q251x11v028972

On Mon, 2012-03-05 at 11:45 +1100, Stephen Rothwell wrote:
> Hi Trond,
> 
> After merging the nfs tree, today's linux-next build
> (powerpc_ppc64_defconfig) failed like this:
> 
> fs/nfs/callback_xdr.c: In function 'decode_stateid':
> fs/nfs/callback_xdr.c:144:16: error: 'nfs4_stateid' has no member named 'data'
> 
> Caused by commit 4af2db6d9480 ("NFSv4: Simplify the struct nfs4_stateid").
> 
> I have used the nfs tree from next-20120302 for today.

Hi Stephen,

Thanks! This bug should now be fixed up in the new commit
dc9ea892baa10df52337c9d4e83146fe9798c5df.

Cheers
 Trond
-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
