Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2JAM4H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 08:56:07 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:36876 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732Ab2JAM4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 08:56:06 -0400
Date: Mon, 1 Oct 2012 18:25:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] uprobes: register/unregister bugfixes
Message-ID: <20121001125552.GA27781@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194438.GA11222@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120930194438.GA11222@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100112-2876-0000-0000-000000A0F7D0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This is on top of "[PATCH 0/3] uprobes: mprotect fixes" series,
> which is still waiting for review...
> 

Did you mean [PATCH 0/4] uprobes: remove is_swbp_at_addr() from
register/unregister?

I have already reviewed and acked "[PATCH 0/3] uprobes: mprotect fixes"
series".  

Got distracted by the register/unregister bug that we were discussing
offline.  Reviewing and testing both the pending series.

-- 
Thanks and Regards
Srikar

