Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112Ab2ILEPm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 00:15:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54142 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab2ILEPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 00:15:40 -0400
Message-ID: <50500C5C.8060006@zytor.com>
Date: Tue, 11 Sep 2012 21:15:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Subject: Re: [PATCH 1/2] module: add syscall to load module from fd
References: <1346955201-8926-1-git-send-email-keescook@chromium.org>
In-Reply-To: <1346955201-8926-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2012 11:13 AM, Kees Cook wrote:
> Instead of (or in addition to) kernel module signing, being able to reason
> about the origin of a kernel module would be valuable in situations
> where an OS already trusts a specific file system, file, etc, due to
> things like security labels or an existing root of trust to a partition
> through things like dm-verity.
>
> This introduces a new syscall (currently only on x86), similar to
> init_module, that has only two arguments. The first argument is used as
> a file descriptor to the module and the second argument is a pointer to
> the NULL terminated string of module arguments.
>

Please use the standard naming convention, which is an f- prefix (i.e. 
finit_module()).

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

