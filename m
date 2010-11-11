Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab0KKUPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 15:15:32 -0500
Received: from tundra.namei.org ([65.99.196.166]:34645 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756027Ab0KKUPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 15:15:31 -0500
Date: Fri, 12 Nov 2010 07:14:35 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        kees.cook@canonical.com, linux-security-module@vger.kernel.org
Subject: Re: [PATCH v3] Restrict unprivileged access to kernel syslog
In-Reply-To: <20101111085514.GA18789@elte.hu>
Message-ID: <alpine.LRH.2.00.1011120713310.29212@tundra.namei.org>
References: <1289431735.3847.9.camel@dan> <20101110154956.83a3f84d.akpm@linux-foundation.org> <20101111085514.GA18789@elte.hu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Ingo Molnar wrote:

> 
> * Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > > CC: stable <stable@kernel.org>
> > 
> > hm.  Reasons for this?
> 
> I dont think so. Can we still try it for .37 though?

I don't have any objections, but how about we give it a week in -next at 
least?



-- 
James Morris
<jmorris@namei.org>
