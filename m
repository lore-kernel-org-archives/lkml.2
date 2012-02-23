Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058Ab2BWHeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:34:31 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42312 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab2BWHea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:34:30 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of chaitanyag3.14@gmail.com designates 10.229.77.141 as permitted sender) smtp.mail=chaitanyag3.14@gmail.com; dkim=pass header.i=chaitanyag3.14@gmail.com
MIME-Version: 1.0
From: chaitanya g <chaitanyag3.14@gmail.com>
Date: Thu, 23 Feb 2012 13:04:09 +0530
Message-ID: <CAOvk4sHM0buk8TW1w8n3EgnNHh6r=57RTUQXKNrCeBFcXjQ7Sg@mail.gmail.com>
Subject: Linux kernel : sysctl registering table under same proc name (path)
 gives warning and call trace while unregistering
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello there,

I am creating a sysctl kernel module to register 2 hierarchy under
same proc name. For e.g.

  my_net
  |          |
net1  net2
 |         |
t1        t2

So, I used register_sysctl_paths() API. Everything works fine when
registering the sysctl tables net1 net2 under path name my_net.

Problem is when unregistering the tables dmesg shows kernel tainted
warning and a call trace.

Here, is pastebin link to the warning message http://pastebin.com/NfLQhikJ

Here is pastebin link to module source http://pastebin.com/jSfPW5Y5

Kindly, please help me to resolve this panic.

Thanks,
Chaitanya
