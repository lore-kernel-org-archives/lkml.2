Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab2JMKSM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 06:18:12 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:63459 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2JMKSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 06:18:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121013022632.024527228@goodmis.org>
References: <20121013022632.024527228@goodmis.org>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Sat, 13 Oct 2012 11:17:46 +0100
X-Google-Sender-Auth: N2IPBDwrAIpxngKfVnrtnzpBjGM
Message-ID: <CAHkRjk4D87V9F2-Y5d1A-s+mnt_TpkOSg+dLz6cRtR25aqqoUg@mail.gmail.com>
Subject: Re: [PATCH 00/25] asm-generic: Convert all to use Kbuild file
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 13 October 2012 03:26, Steven Rostedt <rostedt@goodmis.org> wrote:
> Recently I suggested to someone that was adding a new asm file that
> currently only contained an x86 change to add a header in all archs
> that was just a wrapper to point to the asm-generic version. I suggested
> this because that's the way we use to do it and just to refresh my
> memory, I looked at div64.h in a few archs and saw that was the case.
>
> After having the change done and just after finishing testing it, I was
> notified that the "proper" way of doing this is to add it to the
>
>   arch/*/include/asm/Kbuild
>
> file, as 'generic-y += foo.h' and it will reference the asm-generic
> file automatically. Well it would have been nice if I knew this before
> and wasn't confused by seeing the incorrect method.

Since you are  cleaning this up already, could you please merge these
patches into your series:

https://lkml.org/lkml/2012/10/11/291

The first patch adds support for generic-y in the new
arch/*/include/uapi/asm/Kbuild file, followed by few patches to
convert three architectures. There will probably be more to convert
after -rc1.

Thanks.

-- 
Catalin
