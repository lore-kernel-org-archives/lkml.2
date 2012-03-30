Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728Ab2C3XzJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 19:55:09 -0400
Received: from masquerade.micron.com ([137.201.242.130]:47853 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511Ab2C3XzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 19:55:06 -0400
From: "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONT - Type 2]" 
	<asamymuthupa@micron.com>
To: Ren Mingxin <renmx@cn.fujitsu.com>
CC: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>,
        VIRTUAL <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH 3/4] block: replace rssd_disk_name_format() to
 disk_name_format()
Thread-Topic: [PATCH 3/4] block: replace rssd_disk_name_format() to
 disk_name_format()
Thread-Index: AQHNDlr4t9IsT32K8UyBqG6eXi4OGZaDcyEA
Date: Fri, 30 Mar 2012 23:54:12 +0000
Message-ID: <4F764778.1030406@micron.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
 <4F758297.5020600@cn.fujitsu.com>
In-Reply-To: <4F758297.5020600@cn.fujitsu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
x-ms-exchange-imapappendstamp: NTXBOICAS03.micron.com (14.01.0355.001)
x-originating-ip: [137.201.88.182]
x-tm-as-product-ver: SMEX-10.0.0.4152-6.500.1024-18808.001
x-tm-as-result: No--25.989500-0.000000-31
x-tm-as-user-approved-sender: Yes
x-tm-as-user-blocked-sender: No
x-mt-checkinternalsenderrule: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <1E778E757F563B4A8AC9502D61A5B220@exchange>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2UNtIaa020591

On 3/30/2012 2:53 AM, Ren Mingxin wrote:

>  Currently, block core has been supplied "disk_name_format()", so
> we should remove duplicate function "rssd_disk_name_format()"
> and use the new function to format rssd disk names.
> 
> Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
> ---
>  mtip32xx.c |   33 +--------------------------------
>  1 file changed, 1 insertion(+), 32 deletions(-)


Looks fine.

Should the subject be "mtip32xx: ..." instead of "block: ..."? I
understand "block:" as relating to block core. I am fairly new here. If
"block:" can be used for block drivers too, that is fine too.

--
Regards,
Asai Thambi
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
