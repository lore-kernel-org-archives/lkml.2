Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881Ab2IUCbV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 22:31:21 -0400
Received: from tundra.namei.org ([65.99.196.166]:49492 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751Ab2IUCbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 22:31:19 -0400
Date: Fri, 21 Sep 2012 12:22:44 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
In-Reply-To: <1348179300-11653-1-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.02.1209211221390.16498@tundra.namei.org>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Sep 2012, Kees Cook wrote:

> Earlier proposals for appending signatures to kernel modules would not be
> useful in Chrome OS, since it would involve adding an additional set of
> keys to our kernel and builds for no good reason: we already trust the
> contents of our root filesystem. We don't need to verify those kernel
> modules a second time. Having to do signature checking on module loading
> would slow us down and be redundant. All we need to know is where a
> module is coming from so we can say yes/no to loading it.

Just out of interest, has anyone else expressed interest in using this 
feature?



-- 
James Morris
<jmorris@namei.org>
