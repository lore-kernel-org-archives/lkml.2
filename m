Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288Ab1BJW7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 17:59:37 -0500
Received: from tundra.namei.org ([65.99.196.166]:37071 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756844Ab1BJW7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 17:59:36 -0500
Date: Fri, 11 Feb 2011 09:59:07 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: "Serge E. Hallyn" <serge@hallyn.com>, Gergely Nagy <algernon@balabit.hu>,
        david@lang.hm, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Marc Koschewski <marc@osknowledge.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Nick Bowler <nbowler@elliptictech.com>
Subject: Re: [PATCH 1/1] cap_syslog: don't refuse cap_sys_admin for now
 (v3)
In-Reply-To: <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1102110957380.27143@tundra.namei.org>
References: <20110210144057.GA7193@mail.hallyn.com> <AANLkTin-2uDkjPuSPmUE_HZdpxk9zd=Qop=nf==jsyLA@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Feb 2011, Linus Torvalds wrote:

> On Thu, Feb 10, 2011 at 6:40 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> >
> > Please apply.
> 
> Hmm. So I detest the duplication and the ugly resulting code.  It was
> a bit hard to follow before, now it's just nasty.
> 
> Why not make this all into some nicer helper functions instead -
> something simple like the attached?
>
> UNTESTED! I'm not going to apply it unless I get acks/tested-by's.

Reviewed-by: James Morris <jmorris@namei.org>


-- 
James Morris
<jmorris@namei.org>
