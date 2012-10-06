Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab2JFRgy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 13:36:54 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:50268 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754237Ab2JFRgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 13:36:51 -0400
Date: Sat, 6 Oct 2012 23:07:19 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/7] uprobes: Fix handle_swbp() vs unregister() +
 register() race
Message-ID: <20121006173719.GA9143@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120930194119.GA11278@redhat.com>
 <20120930194211.GA11333@redhat.com>
 <20121006093311.GB9145@linux.vnet.ibm.com>
 <20121006172531.GB9819@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121006172531.GB9819@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12100617-7606-0000-0000-00000442C4E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> for the future changes... (say, we can remove bp if consumers do not
> want to trace this task). Not sure it makes sense to change it right
> now.
> 
> So. Should I leave this patch as is? Or do you want me to move this
> check into handler_chain() and make it return "bool restart"?

Lets keep it as is for now.

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

