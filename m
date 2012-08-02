Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab2HBRvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 13:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589Ab2HBRvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 13:51:16 -0400
Date: Thu, 2 Aug 2012 19:48:04 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Arapov <anton@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        William Cohen <wcohen@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] uprobes: Ignore unsupported instructions in uprobe_mmap
Message-ID: <20120802174804.GA11933@redhat.com>
References: <20120728163157.GA22719@redhat.com> <20120731064730.GB5087@linux.vnet.ibm.com> <20120731124805.GA485@redhat.com> <20120802100515.GC5782@linux.vnet.ibm.com> <20120802135313.GA4334@redhat.com> <20120802164225.GA4268@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120802164225.GA4268@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Srikar Dronamraju wrote:
>
> How about having your fix + my patch to fix the uprobe_mmap()?

(I guess you mean -ENOTSUPP part)

Perhaps...

But, as I said, I think that until we fix the callers uprobe_mmap()
should ignore all errors and proceed. Except, perhaps, it makes sense
to check fatal_signal_pending() to not upset oom-killer.

I already had this patch, but then I decided it would be better to
do other changes first. See my next reply to your another email.

Oleg.

