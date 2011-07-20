Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab1GTOVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:21:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:41341 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418Ab1GTOVt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:21:49 -0400
Date: Wed, 20 Jul 2011 09:21:29 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Tejun Heo <tj@kernel.org>
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
Message-ID: <20110720142129.GB19603@peqn>
References: <20110720140037.GM3455@htj.dyndns.org>
 <20110720140335.GN3455@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720140335.GN3455@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tejun Heo (tj@kernel.org):
> On Wed, Jul 20, 2011 at 04:00:37PM +0200, Tejun Heo wrote:
> > With new ptrace requests, a process can be captured and manipulated
> > practically transparently.  Other than syscall retry or -EINTR failure
> > in special cases and timing difference, everything including job
> > control stop state stays transparent across ptrace operations.
> 
> Ooh, forgot to mention something.  The ptracer can also reliably
> determine whether job control stop is in effect or not, so the whole
> job control state can be captured.

It sounds cool, thanks.  Is this completely separate from Pavel's
CR patchset (which I've not yet gotten around to looking at in
detail)?

-serge
