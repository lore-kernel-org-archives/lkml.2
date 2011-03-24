Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab1CXPOd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 11:14:33 -0400
Received: from kroah.org ([198.145.64.141]:38812 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755766Ab1CXPOb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 11:14:31 -0400
Date: Thu, 24 Mar 2011 08:13:23 -0700
From: Greg KH <greg@kroah.com>
To: linux-kernel@vger.kernel.org, joe@perches.com, akpm@linux-foundation.org,
        rdunlap@xenotime.net
Subject: Re: [BUG]Some warnings happened when compile UML kernel.
Message-ID: <20110324151323.GB501@kroah.com>
References: <20110324045610.GA8186@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110324045610.GA8186@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 12:56:12PM +0800, Harry Wei wrote:
> Hi us,
> 	Recently, i wanna establish a UML for something else. But
> When i compile the UML kernel with linux-2.6.38, it shows some 
> OOPS like following. Maybe they are well. I just worry they will lead
> to some other matters.
> 
> root@jiawei-laptop:/usr/src/linux-2.6.38# make gconfig ARCH=um
> sed < scripts/kconfig/lkc_proto.h > scripts/kconfig/lkc_defs.h 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
>   HOSTCC  scripts/kconfig/gconf.o
> In file included from /usr/include/gtk-2.0/gtk/gtk.h:233,
>                  from /usr/include/libglade-2.0/glade/glade-xml.h:26,
>                  from /usr/include/libglade-2.0/glade/glade.h:28,
>                  from scripts/kconfig/gconf.c:16:
> /usr/include/gtk-2.0/gtk/gtkitemfactory.h:47: warning: function declaration isn’t a prototype
> scripts/kconfig/gconf.c:82: warning: no previous prototype for ‘dbg_sym_flags’

You don't have the proper development libraries on your machine in which
to build 'gconfig'.  Try loading the needed gtk+ devel packages.

thanks,

greg k-h
