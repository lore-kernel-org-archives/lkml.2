Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932398Ab0KKEV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 23:21:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:50807 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310Ab0KKEV5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 23:21:57 -0500
Date: Thu, 11 Nov 2010 15:19:10 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Dan Rosenberg <drosenberg@vsecurity.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, kees.cook@canonical.com,
        security@kernel.org
Subject: Re: [PATCH v3] Restrict unprivileged access to kernel syslog
In-Reply-To: <20101110154956.83a3f84d.akpm@linux-foundation.org>
Message-ID: <alpine.LRH.2.00.1011111517260.20978@tundra.namei.org>
References: <1289431735.3847.9.camel@dan> <20101110154956.83a3f84d.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Nov 2010, Andrew Morton wrote:

> > +#ifdef CONFIG_SECURITY_DMESG_RESTRICT
> > +int dmesg_restrict = 1;
> > +#else
> > +int dmesg_restrict;
> > +#endif
> 
> You might be able to make this an int type and do
> 
> int dmesg_restrict = CONFIG_SECURITY_DMESG_RESTRICT;

This is cleaner, so if resending the patch, I'd prefer this version.


- James
-- 
James Morris
<jmorris@namei.org>
