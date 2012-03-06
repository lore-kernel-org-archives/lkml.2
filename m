Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031561Ab2CFWvw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:51:52 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:35281 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031497Ab2CFWvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:51:50 -0500
Date: Tue, 6 Mar 2012 23:51:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Aaron Durbin <adurbin@google.com>,
        Paul Turner <pjt@google.com>, Yong Zhang <yong.zhang0@gmail.com>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH 3/5] mips: Use common fork_idle_from_wq in smpboot
Message-ID: <20120306225127.GA29711@linux-mips.org>
References: <1330710103.30167.84.camel@sbsiddha-desk.sc.intel.com>
 <1331070074-31717-1-git-send-email-venki@google.com>
 <1331070074-31717-4-git-send-email-venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331070074-31717-4-git-send-email-venki@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2012 at 01:41:12PM -0800, Venkatesh Pallipadi wrote:

> Cleanup. Instead of reimplementing fork_idle on wq and idle task caching,
> use fork_idle_from_wq().
> 
> Signed-off-by: Venkatesh Pallipadi <venki@google.com>

Looking good; this is code that really shouldn't be replicated a over
several architectures.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
