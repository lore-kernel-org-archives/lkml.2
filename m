Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917Ab0E1SkQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:40:16 -0400
Received: from smtp.outflux.net ([198.145.64.163]:43770 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121Ab0E1SkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:40:12 -0400
Date: Fri, 28 May 2010 11:39:20 -0700
From: Kees Cook <kees.cook@canonical.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-doc@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>, Dave Young <hidave.darkstar@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       James Morris <jmorris@namei.org>, Eric Paris <eparis@redhat.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>
Subject: Re: [PATCH] fs: block cross-uid sticky symlinks
Message-ID: <20100528183920.GJ6056@outflux.net>
References: <20100527201635.GU6056@outflux.net>
 <20100528044026.GA13636@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528044026.GA13636@us.ibm.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 27, 2010 at 11:40:26PM -0500, Serge E. Hallyn wrote:
> > +	if (S_ISLNK(inode->i_mode) &&
> 
> Q: is the S_ISLNK() check actually needed?

I guess not -- I would imagine this function would never be called if it
wasn't true, and the caller would probably run into bigger problems first
anyway.  I will drop this test.

Thanks,

-Kees

-- 
Kees Cook
Ubuntu Security Team
