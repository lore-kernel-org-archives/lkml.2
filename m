Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2IUDHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 23:07:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38578 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756953Ab2IUDHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 23:07:15 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1209211221390.16498@tundra.namei.org>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
	<alpine.LRH.2.02.1209211221390.16498@tundra.namei.org>
Date: Thu, 20 Sep 2012 20:07:14 -0700
X-Google-Sender-Auth: zhci--cbEEYcO74JPr90X-U6VCs
Message-ID: <CAGXu5j+EZq+jwK+=yXkx-SxidLy0qwNne=DxGOiLtgzoYzV0Pg@mail.gmail.com>
Subject: Re: [PATCH 1/4] module: add syscall to load module from fd
From: Kees Cook <keescook@chromium.org>
To: James Morris <jmorris@namei.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Arnd Bergmann <arnd@arndb.de>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 7:22 PM, James Morris <jmorris@namei.org> wrote:
> On Thu, 20 Sep 2012, Kees Cook wrote:
>
>> Earlier proposals for appending signatures to kernel modules would not be
>> useful in Chrome OS, since it would involve adding an additional set of
>> keys to our kernel and builds for no good reason: we already trust the
>> contents of our root filesystem. We don't need to verify those kernel
>> modules a second time. Having to do signature checking on module loading
>> would slow us down and be redundant. All we need to know is where a
>> module is coming from so we can say yes/no to loading it.
>
> Just out of interest, has anyone else expressed interest in using this
> feature?

Yes, in the earlier threads, Mimi spoke up in favor of it as a
possible path for IMA to do signature checking. She sent patches that
updated the LSM hooks to include callback to IMA that were sent to the
lsm list:
http://marc.info/?l=linux-security-module&m=134739023306344&w=2

Serge and Eric both Acked the new hooks too.

-Kees

-Kees

-- 
Kees Cook
Chrome OS Security
