Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab1LBBLB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 20:11:01 -0500
Received: from ozlabs.org ([203.10.76.45]:36397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756361Ab1LBBK6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 20:10:58 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: jbaron@redhat.com, greg@kroah.com, joe@perches.com,
        bart.vanassche@gmail.com, linux-kernel@vger.kernel.org,
        Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 18/25] dynamic_debug: Introduce global fake module param module.ddebug
In-Reply-To: <CAJfuBxzg-Bn8TD-h_kjo=hu4oCpkOLWvuC2NybpqQH5msokk4A@mail.gmail.com>
References: <1322683014-13285-1-git-send-email-jim.cromie@gmail.com> <1322683014-13285-19-git-send-email-jim.cromie@gmail.com> <8739d5t4ne.fsf@rustcorp.com.au> <CAJfuBxzg-Bn8TD-h_kjo=hu4oCpkOLWvuC2NybpqQH5msokk4A@mail.gmail.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 02 Dec 2011 11:20:02 +1030
Message-ID: <87wrafre4l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Dec 2011 01:15:22 -0700, Jim Cromie <jim.cromie@gmail.com> wrote:
> >
> > I think you're missing a neat trick here: we should be able to handle
> > ddebug in the handle_unknown parameter to parse_args().
> >
> > Or am I missing something?
> >
> 
> Jason suggested that too, offlist.
> I pretty much agreed, but wanted to get the 1st 17 sent.
> 
> What gave me pause was this:
> 		pr_debug("Unknown argument: calling %p\n", handle_unknown);

In my code, it's DEBUG(), which is only for people debugging parameter
parsing.  Ignore it, it's normal.  You can delete it if it really
bothers you.

Thanks,
Rusty.
