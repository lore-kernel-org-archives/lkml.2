Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760853Ab0FQXEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 19:04:45 -0400
Received: from tundra.namei.org ([65.99.196.166]:40507 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760512Ab0FQXEd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 19:04:33 -0400
Date: Fri, 18 Jun 2010 09:03:38 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Kees Cook <kees.cook@canonical.com>, Randy Dunlap <rdunlap@xenotime.net>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
In-Reply-To: <20100617233054.330256cf@lxorguk.ukuu.org.uk>
Message-ID: <alpine.LRH.2.00.1006180845290.19732@tundra.namei.org>
References: <20100616221833.GM24749@outflux.net> <20100617000120.13071be8@lxorguk.ukuu.org.uk> <20100616232230.GP24749@outflux.net> <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org> <20100617170453.GV24749@outflux.net> <20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
 <20100617140630.c6ced27a.rdunlap@xenotime.net> <20100617221815.68ce30c5@lxorguk.ukuu.org.uk> <20100617215105.GB24749@outflux.net> <20100617233054.330256cf@lxorguk.ukuu.org.uk>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010, Alan Cox wrote:

> - You can put it together as a security module - which will make people
>   happy and get your stuff upstream. After that you can have a meaningful
>   discussion about stacking

It think this approach is worth pursuing, so that we can also see what's 
there, and determine if there is a need for some form of stacking, or 
whether we can consolidate some of this into library code which the 
various LSMs utilize.

People who don't want to run SELinux / AppArmor / Smack / TOMOYO etc., run 
can still get some protection.


- James
-- 
James Morris
<jmorris@namei.org>
