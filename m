Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab2BBCYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:24:35 -0500
Received: from umail.ceopen.cn ([202.10.79.62]:38167 "HELO ceopen.cn"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753626Ab2BBCYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:24:34 -0500
X-Greylist: delayed 366 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Feb 2012 21:24:33 EST
X-UMAIL-SMTPAUTH: wangjing@300.cn
Date: Thu, 2 Feb 2012 10:18:24 +0800
From: "wangjing" <wangjing@300.cn>
To: "linux-nfs" <linux-nfs@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Cc: "wjk302" <wjk302@gmail.com>
Subject: could modify sillyrename to put files in /tmp
Message-ID: <201202021018234324363@300.cn>
X-mailer: Foxmail 6, 15, 201, 23 [cn]
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q122P8Gn025190

In nfs v3 ,if mulity process visit nfs mount nfs dir ,there sometimes occour .nfsXXX can't delete .

If modify sillyrename to put files in /tmp ,it will be more friendly to nfs user.


the background
   1¡¢Linux fs has   /nfsmnt/work_pub/web and /nfsmnt/work_inwork/web £¬they use NFS V3 mount
   2¡¢there is many process will read and write files in the dir /nfsmnt/work_pub/web 
   3¡¢cron will del  all files in dir  /nfsmnt/work_pub/web in period£¬and will copy all the files which in the dir /nfsmnt/work_inwork/web 

in some times delete all files in  /nfsmnt/work_pub/web will faild ,because there is some .nfsXXXX



My question is :can i modify nfs_sillyrename funncion  in the fs/nfs/dir.c , general all .nfsXXX in /tmp,and make kernel ?




2012-02-02 
wangjing
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
