Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751476Ab1LHHN2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:13:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36186 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab1LHHN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:13:27 -0500
Date: Wed, 7 Dec 2011 23:15:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [rfc 3/3] prctl: Add PR_SET_MM codes to tune up mm_struct
 entires
Message-Id: <20111207231512.519385bb.akpm@linux-foundation.org>
In-Reply-To: <20111208070724.GW21678@moon>
References: <20111129201938.GP5169@outflux.net>
	<20111129202951.GG1775@moon>
	<20111129203714.GH1775@moon>
	<CAGXu5jKDLExXWi+_Hjc+8s7FeuDgQdZcPipMH80LQs+tRyJm2A@mail.gmail.com>
	<20111130173739.GI14515@moon>
	<CAGXu5jL=46_MyxrrB8G4FntnLJBtt+DbvVX0kEXh9n8Ss+Yfsw@mail.gmail.com>
	<20111130182310.GL14515@moon>
	<20111130210622.GM14515@moon>
	<20111207122718.GF21678@moon>
	<20111207144355.c889e22d.akpm@linux-foundation.org>
	<20111208070724.GW21678@moon>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Dec 2011 11:07:24 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> > 
> > The prctl(2) manpage will need to be updated.  Please Cc Michael on all
> > such changes.
> >
> 
> you mean -- Michael Kerrisk, mtk AT man7.org, right?

That isn't what ./MAINTAINERS says?

> > 
> > This is starting to add a non-trivial amount of code.  Perhaps we need
> > to introduce a Kconfig variable to control such things as this, to
> > prevent bloating up kernels which aren't require to support c/r?
> > 
> 
> Dunno, Andrew. Actually I agreed that these snippets are mostly
> needed for c/r only, but the initial idea over all changes was
> to add levers into kernel which might be helpful not only
> for c/r but for someone else as well.

In each instance, a case would need to be made for that.  Plus if
people later come along who want access to these things for other
purposes, they can send a patch!

There will always be people who would *prefer* that this material not
be present in their vmlinux.  For those people, this patch is a
regression!


