Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab0JUHF2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 03:05:28 -0400
Received: from ozlabs.org ([203.10.76.45]:47994 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751962Ab0JUHF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 03:05:27 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Finishing off cpumask...
Date: Thu, 21 Oct 2010 17:35:23 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic; KDE/4.5.1; i686; ; )
Cc: Mike Travis <travis@sgi.com>, anton@samba.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201010211735.23918.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have had five final cpumask patches in my queue for over a year now, and
I'd like to merge them *next* merge window (not this one, too late).

The first two finally convert mm_struct and task_struct to variable cpumasks,
which are the last in the core kernel.  The next two turn off and break
old-style cpumask uses when CONFIG_CPUMASK_OFFSTACK is set, and the final one
actually means we don't allocate all NR_CPUS bits for bitmasks.

Historically, this stuff has revealed issues when turned on, so I'd like it
to have a long baking cycle in Ingo's tree and big-machine testers.

I'm rebasing and retesting now, will post git tree when I have it.

Thanks,
Rusty.
