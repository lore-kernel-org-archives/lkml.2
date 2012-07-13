Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697Ab2GMWCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 18:02:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55902 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751552Ab2GMWCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 18:02:48 -0400
Date: Fri, 13 Jul 2012 15:02:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Alex Kelly <alex.page.kelly@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alex <eshink@gmail.com>
Subject: Re: [PATCH 1/2] Moved core dump functionality into its own file
Message-Id: <20120713150246.c058e7d3.akpm@linux-foundation.org>
In-Reply-To: <CAM_iQpWk7nekZoi5i6yg6Q3hA6Sa1HG2SPjPJ=HFD3cPdbVW9w@mail.gmail.com>
References: <1341275894-9737-1-git-send-email-alex.page.kelly@gmail.com>
	<CAM_iQpWk7nekZoi5i6yg6Q3hA6Sa1HG2SPjPJ=HFD3cPdbVW9w@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012 12:53:34 +0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> On Tue, Jul 3, 2012 at 8:38 AM, Alex Kelly <alex.page.kelly@gmail.com> wrote:
> > From: Alex <eshink@gmail.com>
> >
> > This was done in preparation for making core dump functionality optional.
> >
> > The variable "suid_dumpable" and associated functions are left in fs/exec.c
> > because they're used elsewhere, such as in ptrace.
> >
> > Signed-off-by: Alex Kelly <alex.page.kelly@gmail.com>
> > Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> Looks good to me:

Me too, but the first patch conflicts somewhat with a few pending
changes in linux-next.  I could fix them up, but would prefer that the
result be tested.  Alex, could you please redo the patches against
linux-next or mmotm?

Also, the patch titles could be improved.  I suggest

	coredump: move core dump functionality into its own file
	coredump: make core dump functionality optional

Documentation/SubmittingPatches section 15 describes the thinking here.

Thanks.
