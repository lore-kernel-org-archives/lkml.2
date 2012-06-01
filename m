Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932762Ab2FAN5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:57:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:48981 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932595Ab2FAN5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:57:38 -0400
Date: Fri, 1 Jun 2012 19:26:28 +0530
From: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ryanh@linux.vnet.ibm.com
Subject: perf kvm segfaults while reporting events
Message-ID: <20120601135627.GA3004@linux.vnet.ibm.com>
Reply-To: Pradeep Kumar Surisetty <psuriset@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12060113-2398-0000-0000-0000071E115F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello 

perf kvm generats segfaults while reporting events. 

host & guest:  3.4.0-rc4

1) Copied kallsyms, modules from guest to host. 

2) recorded  events on host and guest & report it using below commands. 


[root@host]# ./perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms --guestmodules=/tmp/guest-modules record -a -o perf.data
^C[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.381 MB perf.data (~16659 samples) ]

[root@host]# ./perf kvm --host --guest --guestkallsyms=/tmp/guest-kallsyms --guestmodules=/tmp/guest-modules report -i perf.data --force
perf: Segmentation fault
[root@host]# 

--Pradeep

