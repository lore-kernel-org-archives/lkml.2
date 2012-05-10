Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761477Ab2EJSxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 14:53:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53674 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760305Ab2EJSxd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 14:53:33 -0400
Date: Thu, 10 May 2012 11:53:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Bryan Wu <bryan.wu@canonical.com>
Cc: rpurdie@rpsys.net, linux-kernel@vger.kernel.org, arnd.bergmann@linaro.org
Subject: Re: [PATCH] MAINTAINERS: Add maintainer for LED subsystem
Message-Id: <20120510115332.7c5a262b.akpm@linux-foundation.org>
In-Reply-To: <CAK5ve-LYW6gkZ1Ew76THu5jJDjfyH57EL6eTGC8s9n6d77a3wQ@mail.gmail.com>
References: <1336609592-3825-1-git-send-email-bryan.wu@canonical.com>
	<20120510111958.7cb00da9.akpm@linux-foundation.org>
	<CAK5ve-LYW6gkZ1Ew76THu5jJDjfyH57EL6eTGC8s9n6d77a3wQ@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2012 02:36:36 +0800
Bryan Wu <bryan.wu@canonical.com> wrote:

> On Fri, May 11, 2012 at 2:19 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Thu, 10 May 2012 08:26:32 +0800
> > Bryan Wu <bryan.wu@canonical.com> wrote:
> >
> >> Add Bryan Wu as the primary maintainer for drivers/leds
> >>
> >> Signed-off-by: Bryan Wu <bryan.wu@canonical.com>
> >> ---
> >> __MAINTAINERS | __ __1 +
> >> __1 file changed, 1 insertion(+)
> >>
> >> diff --git a/MAINTAINERS b/MAINTAINERS
> >> index 7071633..de4e280 100644
> >> --- a/MAINTAINERS
> >> +++ b/MAINTAINERS
> >> @@ -4034,6 +4034,7 @@ F: __ __ __Documentation/scsi/53c700.txt
> >> __F: __ drivers/scsi/53c700*
> >>
> >> __LED SUBSYSTEM
> >> +M: __ Bryan Wu <bryan.wu@canonical.com>
> >> __M: __ Richard Purdie <rpurdie@rpsys.net>
> >> __S: __ Maintained
> >> __F: __ drivers/leds/
> >
> > Please set up a git tree based on Linus mainline, get that tree
> > included in linux-next (by emailing Stephen) and include its git
> > URL in this MAINTAINERS record.
> >
> 
> Actually I have account on kernel.org, but it was removed maybe after
> we restored kernel.org due to attacking. So is possible for me to
> apply it again, I was told I need more GPG  key signed, right? Or I
> will setup a tree in kernel.ubuntu.com/git.

Either's OK by me.  You're at a conference, yes?  A good place to get
keys signed!

> let's setup a leds mailing list, is it possible have on vger? I will
> also monitor lkml with your help.

OK, please ask davem about the mailing list.
