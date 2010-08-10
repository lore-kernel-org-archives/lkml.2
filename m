Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab0HJUcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 16:32:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46603 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab0HJUb5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 16:31:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=buqU2QTN9V7aHbepoHgkCQU58kYt7TqGuEM4IpxYTysx6m9NTPrOIhQ8FG4xjiPrW+
         XUicjNtLiN9XLF9pBO8ImKr5i0Zpx4PdS5vIuX6kqtvgQm6URsoGG6XQnD+6o5jbVhwW
         GYSGBTfAB00fxiXQ93NmEdcS6BVUN438j3bLQ=
MIME-Version: 1.0
Date: Tue, 10 Aug 2010 22:31:55 +0200
Message-ID: <AANLkTin_8qvSGfnKbLhz=RxSkWLhsRNVkM=F_CFxzvv1@mail.gmail.com>
Subject: Low cache usage, lots of free mem :-(
From: =?UTF-8?Q?Maciej_So=C5=82tysiak?= <pysiak@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id o7AKW6Fp029815

Hi,

I have a weird problem. My free -m output is:

root@mkslnx002:/proc/sys/vm# free -m
Â Â Â Â Â Â Â Â Â Â Â Â  totalÂ Â Â Â Â Â  usedÂ Â Â Â Â Â  freeÂ Â Â Â  sharedÂ Â Â  buffersÂ Â Â Â  cached
Mem:Â Â Â Â Â Â Â Â Â Â  987Â Â Â Â Â Â Â  388Â Â Â Â Â Â Â  599Â Â Â Â Â Â Â Â Â  0Â Â Â Â Â Â Â Â  10Â Â Â Â Â Â Â  171
-/+ buffers/cache:Â Â Â Â Â Â Â  206Â Â Â Â Â Â Â  781
Swap:Â Â Â Â Â Â Â Â  1913Â Â Â Â Â Â Â Â  32Â Â Â Â Â Â  1881

This shows as much as 599 MB of free memory while the cache using only 171MB.
Usually people have it the way round ;-)

Now, this is not normal for this server, it used use way more for
cache, but now it doesn't.
That forces the apps to fetch for iscsi storage more often than I'd like it to.

What might've happened to the OS that it's refusing to use more memory as cache?
The server got slower and I'd like to be able to revert the situation
without a reboot.

Please CC me, I'm not on the list.

Thanks!
Maciej
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
