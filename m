Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab2LWTVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 14:21:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab2LWTVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 14:21:41 -0500
Date: Sun, 23 Dec 2012 20:21:09 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: Kill uprobe_events, use RB_EMPTY_ROOT()
	instead
Message-ID: <20121223192109.GA17958@redhat.com>
References: <20121125223331.GA24788@redhat.com> <20121125223344.GA24801@redhat.com> <20121213143501.GF3902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121213143501.GF3902@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13, Srikar Dronamraju wrote:
>
> * Oleg Nesterov <oleg@redhat.com> [2012-11-25 23:33:44]:

almost month ago ;)

> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

but what about 2/3 and 3/3?

I'd like to send the final (and technically trivial) series which
actually turns the filtering on.

Oleg.

