Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751327Ab2LaIfs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 03:35:48 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45601 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab2LaIfo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 03:35:44 -0500
Date: Mon, 31 Dec 2012 14:05:34 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>, Frank Eigler <fche@redhat.com>,
        Josh Stone <jistone@redhat.com>,
        "Suzuki K. Poulose" <suzuki@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] uprobes: Change handle_swbp() to expose bp_vaddr
	to handler_chain()
Message-ID: <20121231083534.GA5879@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20121230154657.GA28488@redhat.com> <20121230154722.GA28513@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121230154722.GA28513@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12123108-5806-0000-0000-00001D9674CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 30, 2012 at 04:47:22PM +0100, Oleg Nesterov wrote:
> Change handle_swbp() to set regs->ip = bp_vaddr in advance, this is
> what consumer->handler() needs but uprobe_get_swbp_addr() is not
> exported.
> 
> This also simplifies the code and makes it more consistent across
> the supported architectures. handle_swbp() becomes the only caller
> of uprobe_get_swbp_addr().

The arch agnostic bits look fine to me.

> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

