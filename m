Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab2IWOkK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 10:40:10 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51041 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab2IWOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 10:40:09 -0400
MIME-Version: 1.0
Date: Sun, 23 Sep 2012 16:40:07 +0200
Message-ID: <CAFLxGvxqdtE1Uyqib9Qwo4azCVQbh=3vc_xxeAfAqDQOAE-J+A@mail.gmail.com>
Subject: Question on /sys/class/tty/tty0/active
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'm booting 3.6-rc6 using KVM and observe the following output:
$ tty
/dev/tty0
$ cat /sys/class/tty/tty0/active
tty1

Why does the active file say I'm on tty1?
There is no tty1, I'm on tty0.
(Also "who" reports tty0)

It looks like fg_console in vt.c has a bad value...

-- 
Thanks,
//richard
