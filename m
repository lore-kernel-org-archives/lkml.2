Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab0FDEj3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 00:39:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55476 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751451Ab0FDEj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 00:39:27 -0400
Date: Fri, 4 Jun 2010 05:39:06 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kees Cook <kees.cook@canonical.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Dave Young <hidave.darkstar@gmail.com>, Eric Paris <eparis@redhat.com>,
       Christoph Hellwig <hch@infradead.org>, James Morris <jmorris@namei.org>,
       linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jiri Kosina <jkosina@suse.cz>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: [PATCH v6] fs: allow protected cross-uid sticky symlinks
Message-ID: <20100604043906.GB31073@ZenIV.linux.org.uk>
References: <20100603080158.GE4971@outflux.net>
 <20100603104149.78402075@lxorguk.ukuu.org.uk>
 <20100603184054.GA4714@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603184054.GA4714@outflux.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 11:40:54AM -0700, Kees Cook wrote:

> At this point, I believe I've addressed the specific concerns that Al Viro,
> Eric Paris, and a few others pointed out.  What else needs fixing?

The hell you have.  Let me spell it out for you:

1) You _still_ have not posted the analysis of changes it causes, let alone
explained why they are the right thing to do.

2) You are still doing that for each symlink, no matter where in the path
it might be.  Do (1) and you'll see why it is a BS.

3) You have not bothered to explain why e.g. stat(2) should fail on such
symlinks.  Nevermind figuring out which syscalls need that and which do
not.  Again, (1) would be the starting point required for the rest.  And
it is needed to decide how to deal with these checks.  Really.
