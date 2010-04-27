Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab0D0Q1q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 12:27:46 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:64374 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752498Ab0D0Q1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 12:27:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JyNE7ntxqO426KHf5c4iKUisbg0U8yz931E1wKFVwM+GQSTMQQp5QiZ6Kx+1QcRNkl
         tvWYB5fqUxXPiIaF+SlxGxEb3cenj7hvfIgz5ozCPewc1DNa7fhBOCDe8eQmv8HO4xg5
         hVNEld4iHKt1y+tSqUam8LqusG1Ikrz5u/sok=
MIME-Version: 1.0
Date: Tue, 27 Apr 2010 21:57:36 +0530
Message-ID: <q2pcfeab66d1004270927we59dd900hc6fb90cb7c1ecf6b@mail.gmail.com>
Subject: threaded interrupt handler
From: ratheesh k <ratheesh.ksz@gmail.com>
To: linux-kernel@vger.kernel.org, netfilter@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Top half of  interrupt is implemented as kernel thread  in my embedded
linux  , this act as a Home  Router . It has a wan -interface (eth1 )
and lan-interface t( eth0 )

https://rt.wiki.kernel.org/index.php/RT_PREEMPT_HOWTO
http://lwn.net/Articles/302043/


1. if i flood packets on my wan network interface , i can see cpu
utilization of  ksoftirq-rx ( kernel thread ) goes high . But  irq-rx
( kernel thread ) cpu utilization remains same . Why is it so ?


2 . I  modified static priority of  ksoftirq-rx  ( using renice )  to
+19 and  my user space application ( say app-x ) is made -19 . But
still my app-x wont get any cycles ??


3 . How do i set scheduling algorithm of all processes and threads to
Round Robin . So that my app-x would get some processor cycles ?
    Should i individually set  scheduling algorithm for each process ?


thanks,
ratheesh
