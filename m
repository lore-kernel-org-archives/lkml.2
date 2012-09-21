Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190Ab2IUQN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 12:13:28 -0400
Received: from lon1-post-1.mail.demon.net ([195.173.77.148]:46329 "EHLO
	lon1-post-1.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755291Ab2IUQNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 12:13:24 -0400
Message-ID: <1348244001.1660.14.camel@castor.rsk>
Subject: perf bench unexpected behaviour
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Fri, 21 Sep 2012 17:13:21 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
If I run
	perf bench --format=simple all > test.out

I get this line repeated hundreds of times in test.out

	# Running sched/messaging benchmark...

interleaved with the useful output.
It's only printed once if I call it from the command line, it just
redirecting to a file that does odd things. 

AFAICT the message is only printed once, so any ideas why it does this? 
and is there anything I can do to stop it?

This is on 3.6-rc*, I haven't tried any earlier kernels.

thanks
Richard


