Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757063Ab2BCQry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:47:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49153 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab2BCQrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:47:53 -0500
Date: Fri, 3 Feb 2012 17:41:29 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120203164129.GA5341@redhat.com>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org> <20120203162519.GB805@google.com> <20120203163025.GI11834@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120203163025.GI11834@moon>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Cyrill Gorcunov wrote:
>
> On Fri, Feb 03, 2012 at 08:25:19AM -0800, Tejun Heo wrote:
>
> > Ummm... this really doesn't fit in ptrace.  Cyrill, why not put it
> > together with other params you're exporting?

I agree. And to me this looks strange: some info is exported via /proc,
some things need ptrace.

> We could add it to /proc/pid/stat (but I fear Andrew Morton shoot me then ;)

may be you can add /proc/pid/misc_ugly^Wrandom_things_for_cr which
you can extend as needed ;)

Oleg.

