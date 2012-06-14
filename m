Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751154Ab2FNFZx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 01:25:53 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:33192 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab2FNFZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 01:25:22 -0400
Date: Thu, 14 Jun 2012 10:55:16 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] uprobes: misc cleanups
Message-ID: <20120614052516.GB9089@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20120613184933.GA13870@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120613184933.GA13870@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061405-5930-0000-0000-000008D5BCCC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 08:49:33PM +0200, Oleg Nesterov wrote:
> Hello,
> 
> On top of the previous uprobes patches I sent.
> 
> I was going to cleanup write_opcode(), but it turns out we
> should cleanup the callers first.
> 
> Srikar, Ananth, please review and tell me what do you think.

I don't have an objection to this set in principle, except for the
'convenience' comment on one of the patches.

Ananth

