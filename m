Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932683Ab2IUDMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 23:12:30 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:37820 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab2IUDM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 23:12:29 -0400
Message-ID: <1348196986.23350.7.camel@falcor.watson.ibm.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Date: Thu, 20 Sep 2012 23:09:46 -0400
In-Reply-To: <alpine.LRH.2.02.1209211221390.16498@tundra.namei.org>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
	 <alpine.LRH.2.02.1209211221390.16498@tundra.namei.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12092103-7408-0000-0000-000008AD874C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-21 at 12:22 +1000, James Morris wrote:
> On Thu, 20 Sep 2012, Kees Cook wrote:
> 
> > Earlier proposals for appending signatures to kernel modules would not be
> > useful in Chrome OS, since it would involve adding an additional set of
> > keys to our kernel and builds for no good reason: we already trust the
> > contents of our root filesystem. We don't need to verify those kernel
> > modules a second time. Having to do signature checking on module loading
> > would slow us down and be redundant. All we need to know is where a
> > module is coming from so we can say yes/no to loading it.
> 
> Just out of interest, has anyone else expressed interest in using this 
> feature?

I'm not so interested in this particular use case, but am interested in
using the new syscall's file descriptor for measuring/appraising a
kernel module's integrity.

thanks,

Mimi


