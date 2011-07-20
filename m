Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751888Ab1GTOXt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:23:49 -0400
Received: from mail-ey0-f171.google.com ([209.85.215.171]:52220 "EHLO
	mail-ey0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1GTOXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:23:48 -0400
Date: Wed, 20 Jul 2011 16:23:43 +0200
From: Tejun Heo <tj@kernel.org>
To: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, Serge Hallyn <serge@hallyn.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>,
        Glauber Costa <glommer@parallels.com>, Oleg Nesterov <oleg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Containers <containers@lists.osdl.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [EXAMPLE CODE] Parasite thread injection using PTRACE_SEIZE and
 friends
Message-ID: <20110720142343.GP3455@htj.dyndns.org>
References: <20110720140037.GM3455@htj.dyndns.org>
 <20110720140335.GN3455@htj.dyndns.org>
 <20110720142129.GB19603@peqn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720142129.GB19603@peqn>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Jul 20, 2011 at 09:21:29AM -0500, Serge Hallyn wrote:
> Quoting Tejun Heo (tj@kernel.org):
> > On Wed, Jul 20, 2011 at 04:00:37PM +0200, Tejun Heo wrote:
> > > With new ptrace requests, a process can be captured and manipulated
> > > practically transparently.  Other than syscall retry or -EINTR failure
> > > in special cases and timing difference, everything including job
> > > control stop state stays transparent across ptrace operations.
> > 
> > Ooh, forgot to mention something.  The ptracer can also reliably
> > determine whether job control stop is in effect or not, so the whole
> > job control state can be captured.
> 
> It sounds cool, thanks.  Is this completely separate from Pavel's
> CR patchset (which I've not yet gotten around to looking at in
> detail)?

Hmmm... there are some intersecting parts but they don't completely
overlap.  I'll reply to Pavel's series soon.

Thanks.

-- 
tejun
