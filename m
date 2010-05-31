Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab0EaT2B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 15:28:01 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:36862 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756254Ab0EaT16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 15:27:58 -0400
Date: Mon, 31 May 2010 20:27:45 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v2] fs: block cross-uid sticky symlinks
Message-ID: <20100531192745.GR31073@ZenIV.linux.org.uk>
References: <20100531030402.GQ6056@outflux.net>
 <20100531112314.373b0f26@lxorguk.ukuu.org.uk>
 <20100531175008.GC4098@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100531175008.GC4098@outflux.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 31, 2010 at 10:50:08AM -0700, Kees Cook wrote:

> > Give your users their own /tmp. No kernel mods, no misbehaviours, no
> > weirdomatic path walking hackery. No kernel patch needed that I can see.
> 
> Some real applications expect to share /tmp (e.g. "screen").

/tmp/screen-exchange, you mean?  Such a brilliant idea on multiuser system...
