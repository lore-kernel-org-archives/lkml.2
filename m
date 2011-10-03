Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab1JCRqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 13:46:49 -0400
Received: from filtteri1.pp.htv.fi ([213.243.153.184]:42446 "EHLO
	filtteri1.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238Ab1JCRqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 13:46:43 -0400
Date: Mon, 3 Oct 2011 20:46:42 +0300
From: Adrian Bunk <bunk@stusta.de>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Andy Lutomirski <luto@mit.edu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [3.1 patch] x86: default to vsyscall=native
Message-ID: <20111003174642.GB3072@localhost.pp.htv.fi>
References: <20111003090846.GA25136@localhost.pp.htv.fi>
 <CAFLxGvwFcn+YAWveuYV4roo7ZDmx8VkWWYxJ52_qt3cw1e4TWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFLxGvwFcn+YAWveuYV4roo7ZDmx8VkWWYxJ52_qt3cw1e4TWQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:19:59PM +0200, richard -rw- weinberger wrote:
> Adrian,
> 
> On Mon, Oct 3, 2011 at 11:08 AM, Adrian Bunk <bunk@stusta.de> wrote:
> > After upgrading a kernel the existing userspace should just work
> > (assuming it did work before ;-) ), but when I upgraded my kernel
> > from 3.0.4 to 3.1.0-rc8 a UML instance didn't come up properly.
> 
> Are only old UML kernels like 2.6.30.1 affected?

I don't know, that's my only running UML instance.

> Anyway, it's time to upgrade my main machine to 3.1.0-rc8 to observe
> some new UML issues. ;-)
> 
> -- 
> Thanks,
> //richard

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

