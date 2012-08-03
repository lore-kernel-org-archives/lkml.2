Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab2HCLMz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 07:12:55 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:41785 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752922Ab2HCLMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 07:12:49 -0400
MIME-Version: 1.0
In-Reply-To: <20120709175053.GE8185@somewhere.redhat.com>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
	<20120709175053.GE8185@somewhere.redhat.com>
Date: Fri, 3 Aug 2012 13:12:47 +0200
Message-ID: <CAFTL4hzT-ZENm=DTTnPGOHJ5qGKEU=gh2y=9ksDehi7rFawxaQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/9 Frederic Weisbecker <fweisbec@gmail.com>:
> On Tue, Jun 19, 2012 at 03:43:07PM +0200, Frederic Weisbecker wrote:
>> Not sure to which tree this should go. The scheduler one may be.
>> Anyway if you're fine with it, it is pullable at:
>>
>> git://github.com/fweisbec/linux-dynticks.git
>>       virt-cputime
>
> Ping. Are you guys fine with the patchset?

Re-ping :)
