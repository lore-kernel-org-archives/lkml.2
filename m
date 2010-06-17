Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760758Ab0FQVGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 17:06:43 -0400
Received: from xenotime.net ([72.52.115.56]:33956 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760727Ab0FQVGl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 17:06:41 -0400
Date: Thu, 17 Jun 2010 14:06:30 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Kees Cook <kees.cook@canonical.com>, James Morris <jmorris@namei.org>,
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
Message-Id: <20100617140630.c6ced27a.rdunlap@xenotime.net>
In-Reply-To: <20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
References: <20100616221833.GM24749@outflux.net>
	<20100617000120.13071be8@lxorguk.ukuu.org.uk>
	<20100616232230.GP24749@outflux.net>
	<alpine.LRH.2.00.1006172336390.17282@tundra.namei.org>
	<20100617170453.GV24749@outflux.net>
	<20100617215349.2fac02f5@lxorguk.ukuu.org.uk>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jun 2010 21:53:49 +0100 Alan Cox wrote:

> > > SELinux users would not need the other LSM, and stacking is thus not 
> > > required.
> > 
> > But if a user wants to disable ptrace using the SELinux LSM and then
> > also disable sticky-symlinks via the ItsHideous LSM, they're out of luck.
> 
> Thats a nonsensical configuration so we don't care. If you are using
> SELinux you just do it via SELinux. If you are doing it via
> UbuntuHasToBeDifferent then you do it via that.


Well, surely there are people who use something other than Ubuntu
and also care about not using SELinux... eh?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
