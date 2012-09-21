Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab2IUPn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 11:43:28 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:48312 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578Ab2IUPnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 11:43:23 -0400
MIME-Version: 1.0
In-Reply-To: <20120921145930.GA28875@flint.arm.linux.org.uk>
References: <1348179300-11653-1-git-send-email-keescook@chromium.org>
	<1348179300-11653-3-git-send-email-keescook@chromium.org>
	<201209211315.06668.arnd@arndb.de>
	<20120921145930.GA28875@flint.arm.linux.org.uk>
Date: Fri, 21 Sep 2012 08:43:22 -0700
X-Google-Sender-Auth: X_qeRFNrpW5oGulLGVaXoithNQc
Message-ID: <CAGXu5jLgCuBe3ssXYhW=Rg+WQii0nu9P4wrdZhyT1X4iC4vP9Q@mail.gmail.com>
Subject: Re: [PATCH 3/4] ARM: add finit_module syscall to ARM
From: Kees Cook <keescook@chromium.org>
To: Russell King <rmk@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        James Morris <james.l.morris@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Eric Paris <eparis@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 21, 2012 at 7:59 AM, Russell King <rmk@arm.linux.org.uk> wrote:
> On Fri, Sep 21, 2012 at 01:15:06PM +0000, Arnd Bergmann wrote:
>> On Thursday 20 September 2012, Kees Cook wrote:
>> > Add finit_module syscall to the ARM syscall list.
>> >
>> > Signed-off-by: Kees Cook <keescook@chromium.org>
>> > Acked-by: Arnd Bergmann <arnd@arndb.de>
>> > ---
>>
>> My Ack was on the asm-generic patch, not the ARM architecture
>> one. This patch looks ok as well, but Russell is the one
>> maintaining the file, so you should get him to Ack this patch
>> instead.
>
> And, as no one bothered to copy me, I can't give an ack for a patch I've
> not seen.

Arg, sorry for this glitch on both counts. I'll fix these and re-send.

-Kees

-- 
Kees Cook
Chrome OS Security
