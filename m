Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab2CFOQr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 09:16:47 -0500
Received: from mx2.netapp.com ([216.240.18.37]:40363 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758748Ab2CFOQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 09:16:46 -0500
X-IronPort-AV: E=Sophos;i="4.73,540,1325491200"; 
   d="scan'208";a="631081674"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: NFSv4: truncate returns I/O error
Thread-Topic: NFSv4: truncate returns I/O error
Thread-Index: AQHM+4FWAZfcaBFcU0e8HN6S+UC4uZZd1p6A
Date: Tue, 6 Mar 2012 14:16:45 +0000
Message-ID: <1331043405.3260.4.camel@lade.trondhjem.org>
References: <87k42yjb0c.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87k42yjb0c.fsf@tucsk.pomaz.szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEFC0487CD812A4BA0B223F7452C9053@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q26EGrkb008206

On Tue, 2012-03-06 at 11:10 +0100, Miklos Szeredi wrote:
> The attached test program reliably fails on an NFSv4 mount.
> 
> # mount -tnfs -onfsvers=4 127.0.0.1:/ /mnt/nfs
> # ./truncate-test /mnt/nfs/tmp/xyz
> truncate: Input/output error
> 
> Thanks,
> Miklos

Thanks! I'll see if I can reproduce and figure out what's going wrong.

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
