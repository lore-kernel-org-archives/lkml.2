Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0KZPbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:31:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:52155 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902Ab0KZPbn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:31:43 -0500
Message-ID: <4CEFD2BA.5090403@kernel.org>
Date: Fri, 26 Nov 2010 16:31:06 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Robert Richter <robert.richter@amd.com>,
        Dan Carpenter <error27@gmail.com>, Avi Kivity <avi@redhat.com>,
        Bernd Machenschalk <Bernd.Machenschalk@aei.mpg.de>,
        Heinz-Bernd Eggenstein <hbeggenst@aol.com>,
        Oliver Bock <oliver.bock@aei.mpg.de>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Possible FPU context corruption w/ CONFIG_PREEMPT
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:31:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

Heinz-Bernd Eggenstein reports a possible FPU context corruption w/
CONFIG_PREEMPT.  Please take a look at the following forum post.

 http://einstein.phys.uwm.edu/forum_thread.php?id=8516

openSUSE 11.3 desktop kernel which has CONFIG_PREEMPT set is
triggering SIGFPE while the default kernel w/o preemption works fine.
He also notes that a similar bug was fixed in 2008 by commit 06c38d5e
(x86-64: fix FPU corruption with signals and preemption) from Suresh.
Does it ring anyone's bell?

Heinz, is there a simple procedure to reproduce the problem, or would
it be possible to lure you into bisection?

Thanks.

-- 
tejun
