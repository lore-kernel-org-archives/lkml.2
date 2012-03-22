Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031021Ab2CVQ74 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 12:59:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40004 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751023Ab2CVQ7x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 12:59:53 -0400
Message-ID: <4F6B5A78.2060803@zytor.com>
Date: Thu, 22 Mar 2012 09:59:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] x86/build changes for v3.4
References: <20120319163015.GA9988@gmail.com> <CA+55aFzTFa0uxnf7f=kXyJRNE9FGTUtvyfcej1UeMja1-AcZ-A@mail.gmail.com>
In-Reply-To: <CA+55aFzTFa0uxnf7f=kXyJRNE9FGTUtvyfcej1UeMja1-AcZ-A@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 09:57 AM, Linus Torvalds wrote:
> Grr.
> 
> This causes
> 
>   In file included from tools/include/tools/le_byteshift.h:4:0,
>                    from arch/x86/boot/tools/build.c:35:
>   include/linux/types.h:13:2: warning: #warning "Attempt to use kernel
> headers from user space, see http://kernelnewbies.org/KernelHeaders"
> 
> for my build. How come nobody noticed?
> 
>                  Linus
> 

I thought we had noticed and fixed that one a while ago... let me
investigate.

	-hpa

