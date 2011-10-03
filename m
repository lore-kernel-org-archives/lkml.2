Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1JCNUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:20:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65415 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab1JCNUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:20:00 -0400
MIME-Version: 1.0
In-Reply-To: <20111003090846.GA25136@localhost.pp.htv.fi>
References: <20111003090846.GA25136@localhost.pp.htv.fi>
Date: Mon, 3 Oct 2011 15:19:59 +0200
Message-ID: <CAFLxGvwFcn+YAWveuYV4roo7ZDmx8VkWWYxJ52_qt3cw1e4TWQ@mail.gmail.com>
Subject: Re: [3.1 patch] x86: default to vsyscall=native
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Adrian Bunk <bunk@stusta.de>
Cc: Andy Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian,

On Mon, Oct 3, 2011 at 11:08 AM, Adrian Bunk <bunk@stusta.de> wrote:
> After upgrading a kernel the existing userspace should just work
> (assuming it did work before ;-) ), but when I upgraded my kernel
> from 3.0.4 to 3.1.0-rc8 a UML instance didn't come up properly.
>

Are only old UML kernels like 2.6.30.1 affected?
Anyway, it's time to upgrade my main machine to 3.1.0-rc8 to observe
some new UML issues. ;-)

-- 
Thanks,
//richard
