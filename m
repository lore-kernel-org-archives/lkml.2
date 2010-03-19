Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab0CSJwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 05:52:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:36250 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751804Ab0CSJwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 05:52:17 -0400
Date: Fri, 19 Mar 2010 10:52:11 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Greg Thelen <gthelen@google.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] memcg: fix typo in memcg documentation
In-Reply-To: <20100319041842.GI18054@balbir.in.ibm.com>
Message-ID: <alpine.LNX.2.00.1003191051580.18642@pobox.suse.cz>
References: <1268949879-29478-1-git-send-email-gthelen@google.com> <20100319041842.GI18054@balbir.in.ibm.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Mar 2010, Balbir Singh wrote:

> > Updated memory.txt to be more consistent: s/swapiness/swappiness/
> > 
> > Signed-off-by: Greg Thelen <gthelen@google.com>
> > ---
> >  Documentation/cgroups/memory.txt |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
> > index f8bc802..3a6aecd 100644
> > --- a/Documentation/cgroups/memory.txt
> > +++ b/Documentation/cgroups/memory.txt
> > @@ -340,7 +340,7 @@ Note:
> >  5.3 swappiness
> >    Similar to /proc/sys/vm/swappiness, but affecting a hierarchy of groups only.
> > 
> > -  Following cgroups' swapiness can't be changed.
> > +  Following cgroups' swappiness can't be changed.
> 
> Acked-by: Balbir Singh <balbir@linux.vnet.ibm.com>

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
