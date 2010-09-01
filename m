Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab0IAMrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 08:47:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55502 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0IAMra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 08:47:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=EuK+cbqrseeH5s/TATAR642pVAJMSOhJRBh5abtH+76Tw5kVyFYuPTA999ZOVnrpf5
         TinfptPxkLwD3an3i89QXCrah3zFG+Lgz4s+N2Ox5Y51rz+s2EEcmV1J1IwLfffnf4+o
         yTECILKuTDVZQd4g23Mg9OjEUAsTndr+XqCCw=
MIME-Version: 1.0
Date: Wed, 1 Sep 2010 18:17:23 +0530
Message-ID: <AANLkTi=CvnJ7oKoaj1_NjegdvbEoiBtmnVn-xEL8e2D3@mail.gmail.com>
Subject: Issues in Linux HPET example
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

By executing Documentation/timers/hpet_example.c

for polling, I requested for 3 iterations but it seems iteration work
for only 2 as first expired time is always very small.

[root@netbook timers]# ./hpet_example poll /dev/hpet 10 3
-hpet: executing poll
hpet_poll: info.hi_flags 0x0
hpet_poll: expired time = 0x13
hpet_poll: revents = 0x1
hpet_poll: data 0x1
hpet_poll: expired time = 0x1868c
hpet_poll: revents = 0x1
hpet_poll: data 0x1
hpet_poll: expired time = 0x18645
hpet_poll: revents = 0x1
hpet_poll: data 0x1
[root@netbook timers]#

for fasync, I requested for 3 iterations but it shows 4 counts.

[root@netbook timers]# ./hpet_example fasync /dev/hpet 10 3
-hpet: executing fasync
hpet_fasync: info.hi_flags 0x0
hpet_sigio: called
hpet_sigio: called
hpet_fasync: count = 2
hpet_sigio: called
hpet_fasync: count = 3
hpet_sigio: called
hpet_fasync: count = 4
[root@netbook timers]#

How can I fix these issues.

Thanks,
--
Jaswinder Singh.
