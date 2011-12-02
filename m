Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab1LBC2V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 21:28:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44958 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128Ab1LBC2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 21:28:21 -0500
Date: Thu, 1 Dec 2011 18:29:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mark Fasheh <mfasheh@suse.com>,
        ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 44/62] ocfs2: remove the second argument of
 k[un]map_atomic()
Message-Id: <20111201182934.b8dd4c27.akpm@linux-foundation.org>
In-Reply-To: <4ED8322B.8010500@redhat.com>
References: <1322371662-26166-1-git-send-email-amwang@redhat.com>
	<1322371662-26166-45-git-send-email-amwang@redhat.com>
	<20111201201846.GF1495@noexit.corp.google.com>
	<4ED8322B.8010500@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Dec 2011 10:04:27 +0800 Cong Wang <amwang@redhat.com> wrote:

> ___ 2011___12___02___ 04:18, Joel Becker ______:
> > On Sun, Nov 27, 2011 at 01:27:24PM +0800, Cong Wang wrote:
> >>
> >> Signed-off-by: Cong Wang<amwang@redhat.com>
> >
> > Acked-by: Joel Becker<jlbec@evilplan.org>
> >
> > I'm presuming you'll handle pushing this with the entire series.
> >
> 
> Yeah, I hope either Andrew can take all of them

waaay too many patches ;)

> or this can be merged into trivial tree.

I'd suggest you ask Stephen to add the git tree to -next.  Once it's
all suitably reviewed/acked/etc, and we're in the merge window, ask
Linus to pull it.

