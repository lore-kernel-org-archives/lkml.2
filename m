Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005Ab2JXMPl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 08:15:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42831 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab2JXMPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 08:15:40 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Subject: 3.6.0 kernel - ext4 corruption, or?
Date: Wed, 24 Oct 2012 08:15:37 -0400
Message-ID: <002101cdb1e1$47972c60$d6c58520$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac2x3ggd5GgfG161RmGfMsGsLRJ7gw==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I read there was a bug in 3.6.2, is there also one in 3.6.0, or can someone
help explain this?
I did boot systemrescuecd 3.0.0 and ran fsck.ext4 -f partition and there
were no errors reported.
Seems the inode for the directory is missing?

# grep 10.0.0.11 -r /etc
/etc/posfix.old/master.cf:10.0.0.11:smtp         inet  n       -       -
-        1    postscreen

# ls -l /etc/posfix.old/master.cf
-rw-r--r-- 1 root root 13236 Oct 28  2011 /etc/posfix.old/master.cf

# ls -ld /etc/postfix.old
ls: cannot access /etc/postfix.old: No such file or directory

Justin.

