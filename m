Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2KEUe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 15:34:57 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:33143 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab2KEUey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 15:34:54 -0500
Date: Mon, 5 Nov 2012 12:34:44 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
cc: Sasha Levin <sasha.levin@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <levinsasha928@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Dave Jones <davej@redhat.com>, linux-fbdev@vger.kernel.org,
        florianSchandinat@gmx.de
Subject: Re: tty, vt: lockdep warnings
In-Reply-To: <20121105201507.79fe47d7@pyramind.ukuu.org.uk>
Message-ID: <alpine.LNX.2.00.1211051231070.21645@eggly.anvils>
References: <50899507.1040900@oracle.com> <20121026143754.50277bd8@pyramind.ukuu.org.uk> <CA+1xoqdEesjh1EZvR_r7Hn0GUc7741EDWn59qagngcxg4=9bjQ@mail.gmail.com> <20121105175937.26f31d2a@pyramind.ukuu.org.uk> <5097FEA9.2090603@oracle.com>
 <alpine.LNX.2.00.1211051106590.1709@eggly.anvils> <20121105201507.79fe47d7@pyramind.ukuu.org.uk>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 5 Nov 2012, Alan Cox wrote:
> > The fbdev potential for deadlock may be years old, but the warning
> > (and consequent disabling of lockdep from that point on - making it
> > useless to everybody else in need of it) is new, and comes from the
> > commit below in linux-next.
> > 
> > I revert it in my own testing: if there is no quick fix to the
> > fbdev issue on the way, Daniel, please revert it from your tree.
> 
> If you revert it you swap it for a different deadlock - and one that
> happens more often I would expect. Not very useful.

But a deadlock we have lived with for years.  Without reverting,
we're prevented from discovering all the new deadlocks we're adding.

> 
> I'm hoping the framebuffer maintainer will bother to respond to this
> because that's the only way it can be sorted out.

That would be ideal - thanks.

Hugh
