Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab2BQGd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 01:33:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61545 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab2BQGd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 01:33:27 -0500
Date: Fri, 17 Feb 2012 09:33:19 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: David Windsor <dwindsor@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Greg KH <gregkh@linuxfoundation.org>,
        pageexec@freemail.hu,
        Ubuntu security discussion <ubuntu-hardened@lists.ubuntu.com>,
        spender@grsecurity.net, linux-kernel@vger.kernel.org,
        kernel-hardening@lists.openwall.com
Subject: Re: [ubuntu-hardened] Add overflow protection to kref
Message-ID: <20120217063318.GA3330@p183.telecom.by>
References: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
 <20120216204515.GH20420@outflux.net>
 <20120217002405.GB7746@kroah.com>
 <20120217010624.GA6541@outflux.net>
 <20120217014008.GA18763@kroah.com>
 <20120217021109.GC6541@outflux.net>
 <CAEXv5_iRj6zHcKWtV0mgA4i_2u=TB1iQQMYFJAK4r6Ca=pimDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEXv5_iRj6zHcKWtV0mgA4i_2u=TB1iQQMYFJAK4r6Ca=pimDA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 09:48:38PM -0500, David Windsor wrote:
> <snip>
> 
> >>
> >> I have yet to see a patch, so why are we arguing about this?  :)
> >>
> >> Again, I don't know of any kref overflows that have ever happened, so
> >> trying to "protect" this type of thing, seems odd to me.
> >
> > Well, I think the issue was to protect counting things (which seems to
> > be what PaX was after originally), and that kref seemed like the place
> > to put it. I'll let David take it further.
> >
> 
> Patches are forthcoming that will first introduce overflow protection
> to kref.

Patches have already been posted:
http://marc.info/?l=linux-kernel&m=132337541830590&w=4
They were dropped for various (uninteresting) reasons, though.

> Once that's in place, I'll move a few refcount users from
> atomic_t to kref as a reference for other subsystems;

This sucks because dtor argument is mandatory.
