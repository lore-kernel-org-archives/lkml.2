Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754104Ab1LUS6O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 13:58:14 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34982
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754Ab1LUS6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 13:58:11 -0500
Date: Wed, 21 Dec 2011 13:58:03 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Aaron Spear <aspear@vmware.com>
Cc: Ingo Molnar <mingo@elte.hu>, devel@driverdev.osuosl.org,
        Peter Zijlstra <peterz@infradead.org>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>, lttng-dev@lists.lttng.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>
Subject: Re: [lttng-dev] [PATCH 09/11] sched: export task_prio to GPL modules
Message-ID: <20111221185803.GA3650@infradead.org>
References: <20111220110813.GA19105@elte.hu>
 <fb3f11b9-d36f-4160-96ff-c4610af742de@aspear-win7>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb3f11b9-d36f-4160-96ff-c4610af742de@aspear-win7>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vmware using it is more a reason to avoid it than using it.. :)

And most certainly not a reason to export internal kernel details.
