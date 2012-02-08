Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757374Ab2BHQoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 11:44:05 -0500
Received: from nm13.bullet.mail.ird.yahoo.com ([77.238.189.66]:38298 "HELO
	nm13.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755661Ab2BHQoD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 11:44:03 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 528208.3530.bm@omp1016.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=JMBD/hlH6On9CV41Ywflh6iP8EGS9iY/jSuuy7Qizz34GPElWbmpYKE3+1T+j1ya497hrOW82gXxm7L1q5nsNryR2z/Mx7nmO/pi/ou48RxBmd3IX7BU2WrTRPf23puRG4zd5Rp2l6uf6LiD9SKwD9IkdIQ0+TaZ9IzMdKh17Ho=;
X-YMail-OSG: k.NUdcwVM1nxxjOm66wIdDWPJpcjH42EuHObcucMMRerzTc
 ZIMxKct014iYuWUh_Q0Ci685bLl8xg14NaTz.qp59jjvJPKL1QKMFqmSKQgD
 vJxJuNUwqlF7bBiz69scqNOZTdLINgd.eGIc_dQBuX2xVjqYc4oz8gMQ_8Rz
 A4U1QCSR.8S4d1biW2531WoDf5q0UmtZtTKFokNd9miiju0aY6ssJkYMx_YU
 ndkD9AjQjcp6ZLYBHdG7XRkCsSuajL_9NoGg6LNu_xwdLK7agwhdOQ.Usu6s
 B5K8TYekv8lgVzYAiNJG2Ff7q7IFa.Dng7ayTd6Fg8_Axtncw59DxnWyBOjD
 .8ZZYAtsfujNyo6PiFgl69iarsJ8.If6JucASqURWPl0Gl068Bh7PLtHuSeB
 l6XmLLDFNCyJBFlvENOO3bSsRSuQwabPByT8wXsjqJOBIVBXTc93i8Fg-
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.116.338427
Message-ID: <1328719440.33661.YahooMailClassic@web29013.mail.ird.yahoo.com>
Date: Wed, 8 Feb 2012 16:44:00 +0000 (GMT)
From: Paul Parsons <lost.distance@yahoo.com>
Subject: Re: No /dev/root with devtmpfs?
To: Kay Sievers <kay.sievers@vrfy.org>, Kirill Smelkov <kirr@mns.spb.ru>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20120208073559.GA3163@tugrik.mns.mnsspb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 8/2/12, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> "On what disk/partition was / mounted?" is a well-defined
> question for
> cases when backing store is local hdd, so there should be
> well-defined
> answer.
> 
> Previously it was /dev/root, but if /dev/root is not good
> there should be
> some other way for getting the answer. With ext2 I've
> switched to
> `mountpoint -d /` and then grepping major/minor in
> /proc/partitions, but
> with major=0 case I suspect this won't work.
> 
> 
> My use case is to check md5 sum of mbr + bootloader area +
> root-partition early right after the boot, to verify whether
> software is
> not corrupt, and for doing so it was useful to know / ->
> root-partition
> -> whole block device. It's not tivo, just checking for
> medium damage. (I
> understand this would be better done in the early bootloader
> but that
> part is out of my control)

Could you simply use /etc/fstab to identify the root partition?

