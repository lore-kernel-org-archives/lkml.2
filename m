Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759722Ab0JHVGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 17:06:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759664Ab0JHVGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 17:06:10 -0400
From: Andreas Gruenbacher <agruen@suse.de>
Organization: SUSE Labs, Novell Inc.
To: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Subject: Re: [BUG][PATCH][2.6.36-rc3] fanotify: Do not ignore result of permission decisions
Date: Fri, 8 Oct 2010 23:05:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
Cc: Eric Paris <eparis@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <201009071608.02290.tvrtko.ursulin@sophos.com> <201010081500.40494.agruen@suse.de> <201010081711.24373.tvrtko.ursulin@sophos.com>
In-Reply-To: <201010081711.24373.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010082305.36195.agruen@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 October 2010 18:11:23 Tvrtko Ursulin wrote:
> On Friday 08 Oct 2010 14:00:40 Andreas Gruenbacher wrote:
> > Tvrtko,
> >
> > On Wednesday 08 September 2010 10:24:04 Tvrtko Ursulin wrote:
> > > Improved version of the fix which does not include the check
> > > when permission events are not enabled in configuration and
> > > stops processing if no interesting events remain.
> > >
> > > Current code ignores access replies to permission decisions so
> > > fix it in a way which will allow all listeners to still receive
> > > non permission events.
> >
> > I agree with the patch (see comments below), but this explanation is close
> > to incomprehensible and not good as a commit message.
> 
> How about this:
> 
> Current code incorrectly ignores responses to permission decisions. When a
> single deny response has been received record it and do not send more
> permission events. However still send non-permission events to other
> clients.

Much better, thanks.

> Also if ENOMEM, why not try sending to other listeners?

My point, exactly.

Thanks,
Andreas
