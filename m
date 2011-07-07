Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab1GGOHT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 10:07:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41310 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab1GGOHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 10:07:13 -0400
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>
In-Reply-To: <20110707053036.173186930@google.com>
References: <20110707053036.173186930@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 16:06:54 +0200
Message-ID: <1310047614.3282.572.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The very first .config I build gets me:

  CC      kernel/sched.o
/usr/src/linux-2.6/kernel/sched.c:503: warning: ‘struct cfs_bandwidth’ declared inside parameter list
/usr/src/linux-2.6/kernel/sched.c:503: warning: its scope is only this definition or declaration, which is probably not what you want
/usr/src/linux-2.6/kernel/sched.c:504: warning: ‘struct cfs_bandwidth’ declared inside parameter list
In file included from /usr/src/linux-2.6/kernel/sched.c:2175:
/usr/src/linux-2.6/kernel/sched_fair.c: In function ‘move_one_task’:
/usr/src/linux-2.6/kernel/sched_fair.c:2770: error: ‘struct cfs_rq’ has no member named ‘tg’



