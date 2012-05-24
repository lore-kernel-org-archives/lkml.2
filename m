Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965690Ab2EXVgJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 17:36:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58412 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965676Ab2EXVgE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 17:36:04 -0400
Date: Fri, 25 May 2012 06:26:55 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [git pull] Input updates for 3.5-rc0
Message-ID: <20120524212655.GA16113@kroah.com>
References: <20120524083216.GD10562@core.coreip.homeip.net>
 <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxw0HRpizzJZxhhA2oqPpzg4DPUvH2r7YoYfctXS6K=WQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 10:33:49AM -0700, Linus Torvalds wrote:
> On Thu, May 24, 2012 at 1:32 AM, Dmitry Torokhov
> <dmitry.torokhov@gmail.com> wrote:
> > Hi Linus,
> >
> > to receive updates for the input subsystem. You will get:
> 
> I get an annoying conflict, and the reason I call it annoying is not
> because it's hard to resolve, it's because doing that shows that you
> seem to have preferred using
> 
>    dev_dbg(&input->dev.parent, ...)
> 
> over the much more natural
> 
>    dev_dbg(&input->dev, ...)
> 
> which would seem to make more sense.
> 
> Why? Are the input layer device names so bad that using them for debug
> output is useless? And if so, why *are* they so bad?
> 
> I'm going to take your version over Greg's more straightforward one,
> because I assume Greg did things a bit more mindlessly and I think you
> presumably had a *reason* for your extra (stupid) ".parent" part. But
> I'm unhappy with it, because I suspect the reason you did that implies
> that the input layer does something bad.

I reworked these patches 3 different times, they were anything but
"mindless" (well, maybe the first ones were...)  Dmitry and I seem to
disagree on showing useful names to the users, but as he is the one who
needs to handle user issues when they report things, I'll defer to his
version of the changes.

thanks,

greg k-h
