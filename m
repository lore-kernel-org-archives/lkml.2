Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386Ab2FRJHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:07:37 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59263 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab2FRJHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:07:36 -0400
Date: Mon, 18 Jun 2012 11:07:31 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Don Zickus <dzickus@redhat.com>
Cc: baryluk@smp.if.uj.edu.pl, LKML <linux-kernel@vger.kernel.org>,
        JBeulich@suse.com, zhong@linux.vnet.ibm.com
Subject: Re: [PATCH 0/2] x86,nmi: Section header fixes
Message-ID: <20120618090731.GC28824@gmail.com>
References: <1339428809-29360-1-git-send-email-dzickus@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339428809-29360-1-git-send-email-dzickus@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Don Zickus <dzickus@redhat.com> wrote:

> An earlier attempt at a fix for the problem described in the second patch was
> committed to Ingo's tree.  Later a smaller/cleaner patch was posted.  This
> series just reverts the original patch and then applies the second patch.
> 
> The second patch looks a lot cleaner this way instead of just provding the
> delta patch on top.
> 
> Ingo, let me know if this is not what you want.

Wouldnt this be nicer as a delta enhancement, instead of a 
revert+fix-done-differently?

That way we'd should that the original one was good as well, 
it's just that this one is easier to maintain.

Thanks,

	Ingo
