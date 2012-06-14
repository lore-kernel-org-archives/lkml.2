Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093Ab2FNRqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:46:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756047Ab2FNRqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:46:39 -0400
Date: Thu, 14 Jun 2012 19:44:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] uprobes: misc cleanups
Message-ID: <20120614174424.GB8467@redhat.com>
References: <20120613184933.GA13870@redhat.com> <20120614145459.GB12051@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614145459.GB12051@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Srikar Dronamraju wrote:
>
> >
> > On top of the previous uprobes patches I sent.
> >
> > I was going to cleanup write_opcode(), but it turns out we
> > should cleanup the callers first.
> >
> > Srikar, Ananth, please review and tell me what do you think.
> >
>
> The changes look good.
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

Srikar, I assume you agree with the previous changes as well?
If yes, I'll appreciate if you ask them explicitly.

Oleg.

