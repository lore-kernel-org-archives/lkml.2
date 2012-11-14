Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423224Ab2KNTFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:05:44 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:59826 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423130Ab2KNTFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <50A29E28.5040303@mit.edu>
References: <1352587485-18348-1-git-send-email-keescook@chromium.org>
	<50A29E28.5040303@mit.edu>
Date: Wed, 14 Nov 2012 11:05:42 -0800
X-Google-Sender-Auth: Pcpa6jn-txIRSoomooEM00-mYBk
Message-ID: <CAGXu5j+a1dmu92wxct=HBok0aWphL-Vu4xwMB1XffRWgrw8Zcw@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] arch/arm: support seccomp
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Will Deacon <will.deacon@arm.com>, Geremy Condra <gcondra@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Will Drewry <wad@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 11:23 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On 11/10/2012 02:44 PM, Kees Cook wrote:
>> This adds support for seccomp BPF to ARM. When built with the seccomp
>> improvement patch waiting in linux-next ("seccomp: Make syscall skipping
>> and nr changes more consistent"), this passes the seccomp regression
>> test suite: https://github.com/redpig/seccomp
>
> I don't know if this matters much on ARM, but should something like
> https://git.kernel.org/?p=linux/kernel/git/luto/linux.git;a=commit;h=dee1ae5a05149f30baeccb4b8f68f22525ba9ca2
> be added?

Not sure -- I'll leave that up to other folks.

-Kees

-- 
Kees Cook
Chrome OS Security
