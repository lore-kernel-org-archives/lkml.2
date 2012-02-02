Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2BBNui (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:50:38 -0500
Received: from mx2.netapp.com ([216.240.18.37]:30585 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab2BBNug (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:50:36 -0500
X-IronPort-AV: E=Sophos;i="4.71,609,1320652800"; 
   d="scan'208";a="621801247"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: wangjing <wangjing@300.cn>
CC: linux-nfs <linux-nfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, wjk302 <wjk302@gmail.com>
Subject: Re: could modify sillyrename to put files in /tmp
Thread-Topic: could modify sillyrename to put files in /tmp
Thread-Index: AQHM4bGdZwX8e73jsE2/1l3g+/gUYw==
Date: Thu, 2 Feb 2012 13:50:26 +0000
Message-ID: <1328190625.2584.0.camel@lade.trondhjem.org>
References: <201202021018234324363@300.cn>
In-Reply-To: <201202021018234324363@300.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.116]
Content-Type: text/plain; charset="utf-8"
Content-ID: <551A70C38B674B468BF1B77F117ADBD7@tahoe.netapp.com>
MIME-Version: 1.0
X-OriginalArrivalTime: 02 Feb 2012 13:50:28.0062 (UTC) FILETIME=[9F0A5FE0:01CCE1B1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q12Domn4028452

On Thu, 2012-02-02 at 10:18 +0800, wangjing wrote:
> In nfs v3 ,if mulity process visit nfs mount nfs dir ,there sometimes occour .nfsXXX can't delete .
> 
> If modify sillyrename to put files in /tmp ,it will be more friendly to nfs user.

No it wouldn't. Think permissions....

> the background
>    1ã€Linux fs has   /nfsmnt/work_pub/web and /nfsmnt/work_inwork/web ï¼Œthey use NFS V3 mount
>    2ã€there is many process will read and write files in the dir /nfsmnt/work_pub/web 
>    3ã€cron will del  all files in dir  /nfsmnt/work_pub/web in periodï¼Œand will copy all the files which in the dir /nfsmnt/work_inwork/web 
> 
> in some times delete all files in  /nfsmnt/work_pub/web will faild ,because there is some .nfsXXXX
> 
> 
> 
> My question is :can i modify nfs_sillyrename funncion  in the fs/nfs/dir.c , general all .nfsXXX in /tmp,and make kernel ?
> 
NACK.


-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
