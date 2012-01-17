Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab2AQSaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 13:30:11 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56642 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab2AQSaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 13:30:09 -0500
Date: Tue, 17 Jan 2012 22:30:04 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [RFC] fs, proc: Introduce /proc/<pid>/task/<tid>/children entry
 v6
Message-ID: <20120117183004.GK16213@moon>
References: <20120116153231.GF2998@moon>
 <20120116161114.GA17727@redhat.com>
 <20120116162021.GH2998@moon>
 <20120117174049.GA19268@redhat.com>
 <20120117175725.GJ16213@moon>
 <20120117181436.GA21807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120117181436.GA21807@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 07:14:36PM +0100, Oleg Nesterov wrote:
...
> > > Do you see another approach? I don't, so I'd suggest to check
> > > "task->exit_state != EXIT_DEAD" instead of !list_empty().
> > >
> >
> > Well, I thought what if I can find another way without EXIT_DEAD
> > but seems there is no luck.
> 
> Oooooh. Cyrill, it seems I managed to confuse you. And myself.
> 
> exit_ptrace() doesn't use ->sibling, it uses ->ptrace_entry!.
> 
> Sorry!
> 

Heh ;) No worries, I seem to not understand this code enough anyway,
so I'll re-check it again and post an updated version of the patch which
should be reviewed with great caution.

	Cyrill
