Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013Ab1GOHHA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 03:07:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964786Ab1GOHHA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 03:07:00 -0400
Date: Fri, 15 Jul 2011 08:41:47 +0200
From: Greg KH <gregkh@suse.de>
To: Mike Waychison <mikew@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Kconfig: Allow disabling of CONFIG_DEVPORT
Message-ID: <20110715064147.GA1021@suse.de>
References: <1310675693-9204-1-git-send-email-mikew@google.com>
 <20110714212113.GA28639@suse.de>
 <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGTjWtB53vW5B2EJ5=+C3buDAY0RtsfANxx5NhC5aWnmEx08EQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 03:17:24PM -0700, Mike Waychison wrote:
> On Thu, Jul 14, 2011 at 2:21 PM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, Jul 14, 2011 at 01:34:52PM -0700, Mike Waychison wrote:
> >> It would be useful to build kernels with disabled support of /dev/port
> >> for systems where we do not want to allow an administrator to access IO
> >> ports directly.
> >>
> >> To do so however, CONFIG_DEVPORT needs to be user-selectable.  Give this
> >> configuration option a name and help description.
> >>
> >> Google-Bug-Id: 3177114
> >
> > What is that field?  It's not something that I've ever seen before...
> 
> This is for our internal reference.

Internal reference to where?

> > Please don't push internal fields like this to public patches, it only
> > causes confusion...
> 
> It hasn't caused any problems so far.  It helps us track things as we
> pull code back downstream.

Ok, but what happens if all 2000+ different companies start adding their
fields to the signed-off-by: area of the kernel for their internal
tracking systems?

So please, don't do this, it makes no sense to the kernel community at
all and we really don't want to start adding more fields to this area if
we don't have to.

greg k-h
