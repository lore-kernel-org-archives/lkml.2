Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081Ab1EPMjw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 08:39:52 -0400
Received: from vps.jankratochvil.net ([46.28.109.124]:39955 "EHLO
	host1.jankratochvil.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754833Ab1EPMjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 08:39:51 -0400
Date: Mon, 16 May 2011 14:39:30 +0200
From: Jan Kratochvil <jan.kratochvil@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>, vda.linux@googlemail.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: waitpid(WNOHANG) should report SIGCHLD-notified signals  [Re:
 [PATCH 09/11] job control: reorganize wait_task_stopped()]
Message-ID: <20110516123930.GA11933@host1.jankratochvil.net>
References: <20110512154247.GC18599@redhat.com>
 <20110512160253.GK1030@htj.dyndns.org>
 <20110512172506.GA23033@redhat.com>
 <20110512173228.GO1030@htj.dyndns.org>
 <20110515144017.GC31855@host1.jankratochvil.net>
 <20110515164705.GI23665@htj.dyndns.org>
 <20110515174722.GA26361@host1.jankratochvil.net>
 <20110516091318.GQ23665@htj.dyndns.org>
 <20110516121116.GB10469@host1.jankratochvil.net>
 <20110516122756.GT23665@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516122756.GT23665@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On Mon, 16 May 2011 14:27:56 +0200, Tejun Heo wrote:
> On Mon, May 16, 2011 at 02:11:16PM +0200, Jan Kratochvil wrote:
> > It cannot as various GDB-supported platforms do not support threads properly.
> > And you want to have a common codebase to get it will supported.
> > 
> > Besides that it is a matter of coding style, I perfer "poll() model" even on
> > threads-supporting GNU/Linux.
> 
> The above wouldn't be linux kernel's top design concerns, right?

They are - as without threads one needs reliable WNOHANG - while which you say
it is not reliable.


> It's not like new interface is gonna break that, but I think it's gonna be
> more fragile.  Well, it shouldn't be worse than now.

BTW I really do not think this WNOHANG issue is anyhow related to this whole
discussion.


Thanks,
Jan
