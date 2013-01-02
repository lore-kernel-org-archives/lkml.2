Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3ABS5q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 13:57:46 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:45028 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752684Ab3ABS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 13:57:42 -0500
Date: Wed, 2 Jan 2013 10:57:47 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Dave Reisner <dreisner@archlinux.org>, LKML <linux-kernel@vger.kernel.org>,
        Vasiliy Kulikov <segoon@openwall.com>
Subject: Re: [PATCH] debugfs: convert gid= argument from decimal, not octal
Message-ID: <20130102185747.GA28762@kroah.com>
References: <1357134877-27141-1-git-send-email-dreisner@archlinux.org>
 <20130102183351.GA28554@kroah.com>
 <CAGXu5jJ1oGh-ExwQ6f0CMNQjF2cAcLrgWRCz8ho0v4Ve+GjOuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ1oGh-ExwQ6f0CMNQjF2cAcLrgWRCz8ho0v4Ve+GjOuw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 10:42:17AM -0800, Kees Cook wrote:
> On Wed, Jan 2, 2013 at 10:33 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jan 02, 2013 at 08:54:37AM -0500, Dave Reisner wrote:
> >> This patch technically breaks userspace, but I suspect that anyone who
> >> actually used this flag would have encountered this brokenness, declared
> >> it lunacy, and already sent a patch.
> >
> > Kees is the one that originally did this change (I think, right?)
> 
> I recommended the default change, but I think it was Vasiliy that
> added the gid option, IIRC.

Ah, you are right, sorry about that.

> > Kees, any objection to this patch?  Will it break your existing systems?
> 
> Regardless, I have no objection -- this should be int, not octal.

Ok, I'll queue this up when I get back from vacation next week.

thanks,

greg k-h
