Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760831Ab2EITYj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:24:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754296Ab2EITYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:24:38 -0400
Date: Wed, 9 May 2012 12:24:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, tim.gardner@canonical.com
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
Message-Id: <20120509122436.1b612004.akpm@linux-foundation.org>
In-Reply-To: <CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com>
	<CAK5ve-J9uTJKC01XFTzU34MY4z_8yVRwTUVXP99Czu=oL-mqxQ@mail.gmail.com>
	<20120508121946.c20adb87.akpm@linux-foundation.org>
	<CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 May 2012 00:16:14 +0800
Bryan Wu <bryan.wu@canonical.com> wrote:

> On Wed, May 9, 2012 at 3:19 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Wed, 9 May 2012 01:45:43 +0800
> > Bryan Wu <bryan.wu@canonical.com> wrote:
> >
> >> Any comments and suggestions about my v9 patchset.
> >
> > The drivers/leds/ changes look OK to me.
> 
> Thanks a lot, Andrew.
> Richard, what about merging this driver firstly in drivers/leds/?
> 

I'm the LEDs patchmonkey at present.  I can merge the drivers/leds
change if you like, but there doesn't seem much point in that unless
all the other patches get merged.

So my preferred approach would be for the patch series to get merged
via some ARM tree.



Failing that, I can merge them all myself.  Acks from ARM maintainers
and from maintainers of arm-specific drivers are very desirable, but I
wouldn't be surprised if few are forthcoming.

If nothing happens over the next week or so, please remind me (or resend
the patch series) and I'll suck them in.
