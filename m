Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311Ab0FUAxY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 20:53:24 -0400
Received: from tundra.namei.org ([65.99.196.166]:57576 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab0FUAxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 20:53:20 -0400
Date: Mon, 21 Jun 2010 10:52:11 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Theodore Tso <tytso@mit.edu>
cc: Casey Schaufler <casey@schaufler-ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Kees Cook <kees.cook@canonical.com>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-doc@vger.kernel.org,
       Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>,
       linux-security-module@vger.kernel.org
Subject: Re: [PATCH] ptrace: allow restriction of ptrace scope
In-Reply-To: <E1FEE555-566E-4698-8FD8-240076A4F850@mit.edu>
Message-ID: <alpine.LRH.2.00.1006211038250.7537@tundra.namei.org>
References: <20100616221833.GM24749@outflux.net> <20100617000120.13071be8@lxorguk.ukuu.org.uk> <20100616232230.GP24749@outflux.net> <alpine.LRH.2.00.1006172336390.17282@tundra.namei.org> <20100617170453.GV24749@outflux.net> <20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
 <20100617140630.c6ced27a.rdunlap@xenotime.net> <20100617221815.68ce30c5@lxorguk.ukuu.org.uk> <20100617215105.GB24749@outflux.net> <20100617233054.330256cf@lxorguk.ukuu.org.uk> <4C1AE3A8.2020104@schaufler-ca.com>
 <E1FEE555-566E-4698-8FD8-240076A4F850@mit.edu>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Jun 2010, Theodore Tso wrote:

> Yet I would really like a number of features such as this ptrace scope idea ---
> which I think is a useful feature, and it may be that stacking is the only
> way we can resolve this debate.

We've already reached a consensus that these things should be put into a 
separate LSM so we can evaluate the possible need for some form of 
stacking or a security library API.

Note that people using SELinux or AppArmor already have the ability to 
restrict ptrace, and they would thus not need to stack this function if it 
were in a separate LSM.

Do you have a use-case where stacking would be useful here?



- James
-- 
James Morris
<jmorris@namei.org>
