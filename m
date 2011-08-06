Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab1HFNU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 09:20:59 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50318 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756089Ab1HFNU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 09:20:57 -0400
Date: Sat, 6 Aug 2011 15:20:52 +0200
From: Tejun Heo <tj@kernel.org>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Matt Helsley <matthltc@us.ibm.com>, Pavel Emelyanov <xemul@parallels.com>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>, S@mit.edu,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        "David S. Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [EXAMPLE CODE] Parasite thread injection and TCP connection
 hijacking
Message-ID: <20110806132052.GE23937@htj.dyndns.org>
References: <20110806121247.GC23937@htj.dyndns.org>
 <4E3D3768.3070108@mit.edu>
 <20110806130037.GD23937@htj.dyndns.org>
 <CAObL_7FeZQpnOzpXHqSviZdBRUCL+rODbQOBb+6JPSd3PB=fig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAObL_7FeZQpnOzpXHqSviZdBRUCL+rODbQOBb+6JPSd3PB=fig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 06, 2011 at 09:15:45AM -0400, Andrew Lutomirski wrote:
> On Sat, Aug 6, 2011 at 9:00 AM, Tejun Heo <tj@kernel.org> wrote:
> > Actually, the only thing we need on x86_64 is two bytes for the
> > syscall instruction because all params are passed through registers
> > anyway.  We can just set up parameters for mmap, turn on single step,
> > point %rip to syscall in the vsyscall page.  So, either way, I don't
> > think this would be too difficult to solve.
> 
> Not any more -- that syscall instruction is gone as of 3.1.  You could
> search through the vdso to find a syscall, but that seems fragile.
> 
> Why not just add a ptrace command to issue a syscall?

Yeah, maybe.  If this thing proves to be useful enough and looking for
a page to poke under proc too cumbersome.  I'm not against it but
don't really see strong need either at this point.

Thanks.

-- 
tejun
