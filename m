Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066Ab2IUPAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:00:17 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37475 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755518Ab2IUPAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:00:15 -0400
Date: Fri, 21 Sep 2012 15:59:30 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 3/4] ARM: add finit_module syscall to ARM
Message-ID: <20120921145930.GA28875@flint.arm.linux.org.uk>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org> <1348179300-11653-3-git-send-email-keescook@chromium.org> <201209211315.06668.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201209211315.06668.arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 01:15:06PM +0000, Arnd Bergmann wrote:
> On Thursday 20 September 2012, Kees Cook wrote:
> > Add finit_module syscall to the ARM syscall list.
> > 
> > Signed-off-by: Kees Cook <keescook@chromium.org>
> > Acked-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> 
> My Ack was on the asm-generic patch, not the ARM architecture
> one. This patch looks ok as well, but Russell is the one
> maintaining the file, so you should get him to Ack this patch
> instead.

And, as no one bothered to copy me, I can't give an ack for a patch I've
not seen.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
