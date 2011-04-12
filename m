Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758063Ab1DLQCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Apr 2011 12:02:53 -0400
Received: from kroah.org ([198.145.64.141]:44417 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758007Ab1DLQCv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Apr 2011 12:02:51 -0400
Date: Tue, 12 Apr 2011 08:58:01 -0700
From: Greg KH <greg@kroah.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Mikko Vinni <mmvinni@yahoo.com>, Ed Tomlinson <edt@aei.ca>,
        "Gustavo F. Padovan" <padovan@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38 kernel breaks userspace bluetooth management tools
Message-ID: <20110412155801.GA28290@kroah.com>
References: <AANLkTikdco2Ex_xEAgWyOQ9OytQkTqR90Nh2hOnneXSu@mail.gmail.com>
 <loom.20110319T223719-154@post.gmane.org>
 <20110411214416.GB25899@kroah.com>
 <4DA473FE.2040800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DA473FE.2040800@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 12, 2011 at 08:47:10AM -0700, Justin P. Mattock wrote:
> On 04/11/2011 02:44 PM, Greg KH wrote:
> >On Sat, Mar 19, 2011 at 09:46:03PM +0000, Mikko Vinni wrote:
> >>İsmail Dönmez<ismail<at>  namtrac.org>  writes:
> >>>According to http://www.bluez.org/the-management-interface/ bluetooth
> >>>management interface has changed in the 2.6.38 kernel and this ends up
> >>>breaking bluetooth management tools (the ones that get your bluetooth
> >>>mouse working) in both KDE&  Gnome ( see
> >>>https://bugzilla.novell.com/show_bug.cgi?id=680170 ).
> >>
> >>This sounds like http://www.spinics.net/lists/linux-bluetooth/msg10695.html
> >>
> >>The fix is on its way. Nothing is deliberately broken.
> >>
> >>http://git.kernel.org/?p=linux/kernel/git/padovan/bluetooth-next-2.6.git;a=commitdiff;h=b99faf1b798d6d0e33526fd2cef55a405c08ff09;hp=58b6e124aac64bebb2e9e1a136cbd21a5ab0485a
> >
> >That fix isn't in the -stable tree, and doesn't apply cleanly to the
> >.38-stable tree.
> >
> >Can someone provide a backport to stable@kernel.org?
> >
> >thanks,
> >
> >greg k-h
> >
> 
> 
> o.k my diff skills sucks, but(hopefully) backported correctly, sent
> out to stable@kernel.org..
> 
> let me know if you get this or not(seems gmail is not showing my
> sent mail)..

I got it, and the backported patch, thanks.  I'll queue it up in the
next round of stable patches.

greg k-h
