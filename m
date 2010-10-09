Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab0JIJHq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 05:07:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:43810 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab0JIJHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 05:07:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=d0GT5z3uWUlXLtOyHTxgXxSGt1ArML3HNYXqnsUEeL2ofwIuG5c5yyIgBzNot9fubZ
         oBiwPgl/QB633By8YUZAW3WCKJrELKJT/Zvor+cpsA97L/tdJwK7ggja/2C9IkSSWGfb
         XYGYALWAUJYpW9xBcQ2MJQZp+UWjfbgz7oBq4=
MIME-Version: 1.0
Date: Sat, 9 Oct 2010 05:07:42 -0400
Message-ID: <AANLkTi=vJArRbLup=F2duoxx47LFGTT3++4QiFZHJbzQ@mail.gmail.com>
Subject: why could cause PerfTop get nothing output ?
From: Luming Yu <luming.yu@gmail.com>
To: acme@redhat.com
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi acme,

I got nothing output as below, wondering if it was due to too few interrupts ?
Is it possbile to get perf top based on samples from other Perf events?

[root@localhost clocksource0]# rpm -qa | grep perf
perf-2.6.36-0.35.rc7.git0.fc15.x86_64
[root@localhost clocksource0]# uname -a
Linux localhost.localdomain 2.6.36-0.35.rc7.git0.fc15.x86_64 #1 SMP
Wed Oct 6 22:02:54 UTC 2010 x86_64 x86_64 x86_64 GNU/Linux
[root@localhost clocksource0]# perf top

-------------------------------------------------------------------------------
   PerfTop:       0 irqs/sec  kernel:-nan%  exact: -nan% [1000Hz
cycles],  (all, 2 CPUs)
-------------------------------------------------------------------------------

             samples  pcnt  DSO
             _______ _____

Thanks,
Luming
