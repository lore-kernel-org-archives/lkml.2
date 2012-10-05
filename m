Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab2JEKSj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 06:18:39 -0400
Received: from tundra.namei.org ([65.99.196.166]:58102 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab2JEKSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 06:18:37 -0400
Date: Fri, 5 Oct 2012 20:19:03 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH 2/4] security: introduce kernel_module_from_file hook
In-Reply-To: <1349382154-9804-3-git-send-email-keescook@chromium.org>
Message-ID: <alpine.LRH.2.02.1210052018330.18216@tundra.namei.org>
References: <1349382154-9804-1-git-send-email-keescook@chromium.org> <1349382154-9804-3-git-send-email-keescook@chromium.org>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2012, Kees Cook wrote:

> Now that kernel module origins can be reasoned about, provide a hook to
> the LSMs to make policy decisions about the module file. This will let
> Chrome OS enforce that loadable kernel modules can only come from its
> read-only hash-verified root filesystem. Other LSMs can, for example,
> read extended attributes for signatures, etc.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>
> Acked-by: Eric Paris <eparis@redhat.com>
> Acked-by: Mimi Zohar <zohar@us.ibm.com>

Acked-by: James Morris <james.l.morris@oracle.com>


-- 
James Morris
<jmorris@namei.org>
