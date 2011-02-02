Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355Ab1BBFio (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 00:38:44 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50810 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850Ab1BBFin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 00:38:43 -0500
Date: Tue, 1 Feb 2011 21:38:28 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Roland McGrath <roland@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, oleg@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] ptrace: use safer wake up on ptrace_detach()
Message-Id: <20110201213828.c3df7e87.akpm@linux-foundation.org>
In-Reply-To: <20110202053331.C27C6183D88@magilla.sf.frob.com>
References: <1296227324-25295-1-git-send-email-tj@kernel.org>
	<1296227324-25295-3-git-send-email-tj@kernel.org>
	<20110128184601.CBF7C180996@magilla.sf.frob.com>
	<20110131103855.GD7459@htj.dyndns.org>
	<20110201102618.GE14211@htj.dyndns.org>
	<20110201162729.f75be47d.akpm@linux-foundation.org>
	<20110202053331.C27C6183D88@magilla.sf.frob.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  1 Feb 2011 21:33:31 -0800 (PST) Roland McGrath <roland@redhat.com> wrote:

> > Am unable to work out why you tagged it for backporting.  It fixes some
> > observed bug?  Perhaps a regression?
> 
> No observed bug, only theoretical ones (AFAIK, never even a ginned-up
> synthetic test case has been demonstrated).  Certainly not a regression,
> since it has been this (wrong) way since the dawn of time.  I don't think
> this first change is dangerous for -stable, but I have seen no positive
> rationale for pushing it there.
> 

OK, thanks.  I shall destabilize my copy of this patch.
