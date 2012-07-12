Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934005Ab2GLOuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:50:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932528Ab2GLOuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:50:02 -0400
Date: Thu, 12 Jul 2012 16:49:28 +0200
From: Karel Zak <kzak@redhat.com>
To: Richard Weinberger <richard@nod.at>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, jslaby@suse.cz,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, alan@linux.intel.com
Subject: Re: um: TTY fixes (?)
Message-ID: <20120712144928.GA13700@x2.net.home>
References: <1338841657-30358-1-git-send-email-richard@nod.at>
 <20120604221731.5e378fc2@pyramind.ukuu.org.uk>
 <4FCD4161.7060409@nod.at>
 <20120605104125.GA14536@x2.net.home>
 <20120605121532.366a6526@pyramind.ukuu.org.uk>
 <4FCDF996.9010205@nod.at>
 <20120605151719.GA3882@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605151719.GA3882@x2.net.home>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 05:17:19PM +0200, Karel Zak wrote:
> On Tue, Jun 05, 2012 at 02:20:38PM +0200, Richard Weinberger wrote:
> > Am 05.06.2012 13:15, schrieb Alan Cox:
> > > Actually I'd prefer a clever solution which can spot all the fds are the
> > > same process so we can keep compatibility but I've not found a sensible
> > > way to do that.
> > 
> > Me too.
> > 
> > For UML users the current situation is odd.
> > They have to select between:
> > - Having a UML that crashes randomly on some distros.
> > - Applying the TTY fix and break login on every distro that uses util-linux's login.
> > - Applying the TTY fix and patch util-linux too.
> 
>  I'll follow kernel... so if close-before-vhangup is preferred way
>  than I'll modify util-linux login(1). No problem.

 I just fixed login(1) and agetty (--hangup option). The change will
 be available in util-linux v2.23 (rc1 will be this month).

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
