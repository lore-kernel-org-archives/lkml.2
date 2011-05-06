Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932857Ab1EFV3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 17:29:34 -0400
Received: from mga02.intel.com ([134.134.136.20]:48924 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932718Ab1EFV3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 17:29:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,328,1301900400"; 
   d="scan'208";a="639177097"
Message-ID: <4DC4683C.6070208@linux.intel.com>
Date: Fri, 06 May 2011 14:29:32 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fix powerTOP regression with 2.6.39-rc5
References: <4DC45537.6070609@linux.intel.com> <1304713252.25414.2532.camel@gandalf.stny.rr.com> <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
In-Reply-To: <BANLkTim9YvResB+PwRp7QTK-a5VNg2PvmQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/2011 1:51 PM, Linus Torvalds wrote:
>
> You could help fix the tools, and try to avoid the compatibility
> issues that way. There aren't that many of them.

once we have a usable library for these (and by usable, I mean that, eg 
something that someone like Fedora or Ubuntu can package and install)
I will be more than happy to use it in PowerTOP. Today that does not exist.

If such library becomes reality soon, then I'll adjust PowerTOP soon as 
well, and we can remove the padding some time after that even if that is 
really desired.
But we're talking 4 bytes here....

