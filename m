Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab1EJMZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:25:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755980Ab1EJMZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:25:42 -0400
Date: Tue, 10 May 2011 14:24:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Tejun Heo <tj@kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: ptrace pull request for linux-next
Message-ID: <20110510122431.GA12461@redhat.com>
References: <20110329090248.GJ6736@htj.dyndns.org> <20110330101204.7a5459c3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330101204.7a5459c3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On 03/30, Stephen Rothwell wrote:
>
> Hi Tejun,
>
> On Tue, 29 Mar 2011 11:02:48 +0200 Tejun Heo <tj@kernel.org> wrote:
> >
> > Can you please pull from the following tree into linux-next?
> >
> >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git ptrace
> >
> > The tree hosts ongoing ptrace/group stop improvements.  Oleg is in the
> > process of getting a korg account and setting up a dedicated tree and
> > it has been agreed that I maintain a temporary tree to be tested in
> > linux-next until things are properly setup.  The branch is stable and
> > will be pulled verbatim into Oleg's tree once it's up and running.
>
> This will be added from today (I was waiting for -rc1).  I have put you
> and Oleg as contacts for this tree.

Could you please switch from Tejun's tree to

	git://git.kernel.org/pub/scm/linux/kernel/git/oleg/misc.git ptrace

?

Thanks,

Oleg.

