Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab1CYGKr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 02:10:47 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63000 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753492Ab1CYGKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 02:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        b=uZnTYM1nW6X2wALKLIBZwoHF7K/Npw0rPOoJl921EhweyUhQMEuKKdAiVsPlB/oaRy
         LeynvAKf1t9ooGV4S5NJekH2opsfrFfDSI82XBsNbzlxfiDa5HxMNHUGzOUdbFvB/h6O
         g5KY4TfbXjr5k5b5aUhX6PnEe/stIYj8ZpSkI=
Date: Fri, 25 Mar 2011 14:10:27 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, joe@perches.com, akpm@linux-foundation.org,
        rdunlap@xenotime.net
Subject: Re: [BUG]Some warnings happened when compile UML kernel.
Message-ID: <20110325061020.GA2862@gmail.com>
Mail-Followup-To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
	joe@perches.com, akpm@linux-foundation.org, rdunlap@xenotime.net
References: <20110324045610.GA8186@gmail.com>
 <20110324151323.GB501@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110324151323.GB501@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 08:13:23AM -0700, Greg KH wrote:
> On Thu, Mar 24, 2011 at 12:56:12PM +0800, Harry Wei wrote:
> > Hi us,
> > 	Recently, i wanna establish a UML for something else. But
> > When i compile the UML kernel with linux-2.6.38, it shows some 
> > OOPS like following. Maybe they are well. I just worry they will lead
> > to some other matters.
> > 
> > root@jiawei-laptop:/usr/src/linux-2.6.38# make gconfig ARCH=um
> > sed < scripts/kconfig/lkc_proto.h > scripts/kconfig/lkc_defs.h 's/P(\([^,]*\),.*/#define \1 (\*\1_p)/'
> >   HOSTCC  scripts/kconfig/gconf.o
> > In file included from /usr/include/gtk-2.0/gtk/gtk.h:233,
> >                  from /usr/include/libglade-2.0/glade/glade-xml.h:26,
> >                  from /usr/include/libglade-2.0/glade/glade.h:28,
> >                  from scripts/kconfig/gconf.c:16:
> > /usr/include/gtk-2.0/gtk/gtkitemfactory.h:47: warning: function declaration isn¡¯t a prototype
> > scripts/kconfig/gconf.c:82: warning: no previous prototype for ¡®dbg_sym_flags¡¯
> 
> You don't have the proper development libraries on your machine in which
> to build 'gconfig'.  Try loading the needed gtk+ devel packages.
Hi greg,
	In fact, i have also got the same thoughts as you. But i am not
sure it. So i send this mail.

Thanks.
Best Regards.
Harry Wei.

> 
> thanks,
> 
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
