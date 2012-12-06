Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946705Ab2LFSjK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 13:39:10 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:53106 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946405Ab2LFSjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 13:39:08 -0500
Date: Thu, 6 Dec 2012 10:39:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: g.esp@free.fr
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: Linux 3.4.21
Message-ID: <20121206183904.GC2862@kroah.com>
References: <20121203215412.GA5178@kroah.com>
 <925922542.101553160.1354660241220.JavaMail.root@zimbra33-e6.priv.proxad.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <925922542.101553160.1354660241220.JavaMail.root@zimbra33-e6.priv.proxad.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 04, 2012 at 11:30:41PM +0100, g.esp@free.fr wrote:
> 
> 
> ----- Mail original -----
> > De: "Greg KH" <gregkh@linuxfoundation.org>
> > À: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>, torvalds@linux-foundation.org,
> > stable@vger.kernel.org
> > Cc: lwn@lwn.net, "Jiri Slaby" <jslaby@suse.cz>
> > Envoyé: Lundi 3 Décembre 2012 22:54:12
> > Objet: Linux 3.4.21
> > 
> > I'm announcing the release of the 3.4.21 kernel.
> > 
> > All users of the 3.4 kernel series must upgrade.
> > 
> > The updated 3.4.y git tree can be found at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git
> >         linux-3.4.y
> > and can be browsed at the normal kernel.org git web browser:
> >         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
> > 
> > thanks,
> > 
> > greg k-h
> > 
> ...
> > 
> > Robert Richter (1):
> >       x86-32: Fix invalid stack address while in softirq
> > 
> ...
> 
> 
> My build on x86-32 fail with the attached config, should be related to the patch above

Should now be fixed in 3.4.22.

thanks,

greg k-h
