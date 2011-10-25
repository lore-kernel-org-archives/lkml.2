Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756090Ab1JYJ5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:57:05 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:54516 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863Ab1JYJ5C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:57:02 -0400
Subject: Re: [GIT PULL] target: Updates for v3.2-rc1 (round one)
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>,
        Roland Dreier <roland@purestorage.com>
In-Reply-To: <CA+55aFwk6CmHbVfV0eNPPdD4nmRJ_doGB1h6W4ywT-ZBprYR0w@mail.gmail.com>
References: <1319533236.17450.338.camel@haakon2.linux-iscsi.org>
	 <CA+55aFyeCfXV9Fpg9vZywmHtP3PR8+voZpampVqW8TAfCvLv3Q@mail.gmail.com>
	 <1319535924.18871.11.camel@haakon2.linux-iscsi.org>
	 <CA+55aFwk6CmHbVfV0eNPPdD4nmRJ_doGB1h6W4ywT-ZBprYR0w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 Oct 2011 02:56:59 -0700
Message-ID: <1319536619.18871.20.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 11:48 +0200, Linus Torvalds wrote:
> On Tue, Oct 25, 2011 at 11:45 AM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > I don't believe so.  The diff-stat was generated using git-format-patch
> > from target-pending.git with git 1.5.6.5 from the following HEAD:
> 
> It might just be that you apparently have a rather old git version.
> I'm rather more current, and some of the xdiff options have changed (I
> think that 1.5.6 had the old "generate minimal diff" that got disabled
> because it was very slow for some cases)
> 
> I am running git version 1.7.6.4.
> 

That appears to be it, as the gateway I'm pushing to target-pending.git
is running this rather old version of git.  I'm happy to verify this
again from another machine with a more modern version of git, and send a
a followup PULL request later today if you're more comfortable with
that.

Thanks,

--nab


