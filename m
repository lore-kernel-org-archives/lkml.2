Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab0EaXKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 19:10:46 -0400
Received: from tundra.namei.org ([65.99.196.166]:38600 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753635Ab0EaXKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 19:10:44 -0400
Date: Tue, 1 Jun 2010 09:09:10 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <kees.cook@canonical.com>
cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Eric Paris <eparis@redhat.com>, David Howells <dhowells@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
In-Reply-To: <20100531175733.GD4098@outflux.net>
Message-ID: <alpine.LRH.2.00.1006010904190.675@tundra.namei.org>
References: <20100531030402.GQ6056@outflux.net> <20100531103510.GA30021@infradead.org> <20100531175733.GD4098@outflux.net>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 May 2010, Kees Cook wrote:

> Expecting the push-back from VFS, I wrote this patch against commoncaps.
> 
> James, would you take it there (along with the patch to SELinux to call
> out to commoncaps) if there is no way to proceed with the VFS core towards
> solving this?

Isn't this just bypassing the VFS objections?


- James
-- 
James Morris
<jmorris@namei.org>
