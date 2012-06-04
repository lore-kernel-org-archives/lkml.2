Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760704Ab2FDPIp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:08:45 -0400
Received: from casper.infradead.org ([85.118.1.10]:58607 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2FDPIo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:08:44 -0400
Message-ID: <1338822509.28282.65.camel@twins>
Subject: Re: [PATCH] cpuidle: menu: use nr_running instead of cpuload for
 calculating perf mult
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Vladimir Davydov <vdavydov@parallels.com>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Jun 2012 17:08:29 +0200
In-Reply-To: <4FCCBC97.8060101@linux.intel.com>
References: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
	  <1338805967.28282.12.camel@twins> <4FCCB486.4040905@linux.intel.com>
	 <1338817519.28282.54.camel@twins> <4FCCBC97.8060101@linux.intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-04 at 06:48 -0700, Arjan van de Ven wrote:
> it's not about busy, it's about performance sensitive.
> it's not a super nice proxy, no argument, but it's one of the few long
> term ones we have.
> 
I'm still not seeing how it makes any sense at all. Is there an actual
workload here this matters?

It seems to me your own history of idle guestimation is the best measure
there is for this. If you're shown to be too agressive, grow the window,
otherwise shrink it.

You can make that adjustment as slow as you like to include as much
history as you think you need.


