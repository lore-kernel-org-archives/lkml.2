Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752776Ab2EaFml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:42:41 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:47712 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2EaFmj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:42:39 -0400
Date: Thu, 31 May 2012 11:10:23 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] uprobes: kill uprobes_srcu/uprobe_srcu_id
Message-ID: <20120531054023.GQ15587@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120529192721.GA8048@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120529192721.GA8048@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12053105-4242-0000-0000-000001D33948
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Basically the same changes we discussed before.
> 
> Changes:
> 
> 	- do not introduce is_swbp_at_addr_fast(), change
> 	  is_swbp_at_addr() to check current->mm == mm as
> 	  Peter suggested
> 
> 	- 2/7 is new
> 

I have reviewed and tested the patches and I am fine with all the changes.

Thanks Oleg.

-- 
Thanks and Regards
Srikar

