Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755446Ab1KWRh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 12:37:28 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:52426 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754681Ab1KWRh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 12:37:27 -0500
Date: Wed, 23 Nov 2011 09:37:20 -0800
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pedro Alves <pedro@codesourcery.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with
 given pids
Message-ID: <20111123173720.GC29639@google.com>
References: <4EC4F2FB.408@parallels.com>
 <201111221204.39235.pedro@codesourcery.com>
 <20111122153326.GD322@google.com>
 <201111231620.45440.pedro@codesourcery.com>
 <20111123162417.GE25780@google.com>
 <20111123172636.GA25100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123172636.GA25100@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, Oleg.

On Wed, Nov 23, 2011 at 06:26:36PM +0100, Oleg Nesterov wrote:
> On 11/23, Tejun Heo wrote:
> >
> > I see.  So, let's do it for root for now and later add finer grained
> > CAP as necessary/viable.
> 
> Agreed.
> 
> Stupid off-topic question, I am just curious... Why /proc/sys
> dislikes chmod ? I do not understand this code, but it seems
> that it would be simple to change proc_sys_setattr() to respect
> ATTR_MODE and update PROC_I(inode)->sysctl_entry->mode, no?

I have no idea either but suspect it's something historical.  It came
from sysctl and sysctl didn't have any way to diddle with permissions,
so when later adding proc interface, it probably just stayed that way.

Thanks.

-- 
tejun
