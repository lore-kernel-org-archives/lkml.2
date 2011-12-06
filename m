Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228Ab1LFWPW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:15:22 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:39350 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886Ab1LFWPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:15:21 -0500
Date: Wed, 7 Dec 2011 02:15:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Kees Cook <keescook@chromium.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs, proc: Add start_data, end_data, start_brk members to
 /proc/$pid/stat v2
Message-ID: <20111206221515.GP29781@moon>
References: <20111205182010.GV14515@moon>
 <20111206140833.3b43fbeb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111206140833.3b43fbeb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 02:08:33PM -0800, Andrew Morton wrote:
> On Mon, 5 Dec 2011 22:20:11 +0400
> Cyrill Gorcunov <gorcunov@openvz.org> wrote:
> 
> > It helps to dump and restore this mm_struct members.
> 
> Sorry, I'm not going to apply a patch with a changelog like that.
>

OK, I'll update it. The problem is that while we "read" this entries
from procfs, the restoration is supposed to be done via prctl interface
(the patch is in fly, and I'm trying to improve it at moment).

> It needs a full description of how this will be used and why it is
> needed.  So that others can understand and evaluate the proposal, and
> any possible alternatives.
> 
> Such a description would also let us see whether this is just some
> "hey, maybe we'll use this sometime" thing, in which case it should not
> yet be applied.

I understand.

> 
> >  fs/proc/array.c |    7 +++++--
> 
> Also, every change to any procfs interface should have an associated
> change to procfs documentation.  If no relevant document exists then
> heck, write one.  No exceptions.
>

ok, thanks.

	Cyrill
