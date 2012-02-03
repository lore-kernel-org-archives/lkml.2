Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092Ab2BCQyO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:54:14 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49318 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757039Ab2BCQyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:54:10 -0500
Date: Fri, 3 Feb 2012 20:54:04 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120203165404.GJ11834@moon>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
 <20120203162519.GB805@google.com>
 <20120203163025.GI11834@moon>
 <20120203164129.GA5341@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203164129.GA5341@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 03, 2012 at 05:41:29PM +0100, Oleg Nesterov wrote:
> On 02/03, Cyrill Gorcunov wrote:
> >
> > On Fri, Feb 03, 2012 at 08:25:19AM -0800, Tejun Heo wrote:
> >
> > > Ummm... this really doesn't fit in ptrace.  Cyrill, why not put it
> > > together with other params you're exporting?
> 
> I agree. And to me this looks strange: some info is exported via /proc,
> some things need ptrace.
> 
> > We could add it to /proc/pid/stat (but I fear Andrew Morton shoot me then ;)
> 
> may be you can add /proc/pid/misc_ugly^Wrandom_things_for_cr which
> you can extend as needed ;)
> 

I personally don't mind to have /proc/pid/cr directory where we could
export all the data we might ever need. Still some things added (such
as /proc/pid/children) could be useful for other purposes as well, not
only c/r.

	Cyrill
