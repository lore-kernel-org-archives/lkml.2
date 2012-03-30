Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965690Ab2C3VSs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 17:18:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:41180 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965669Ab2C3VSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 17:18:40 -0400
Date: Fri, 30 Mar 2012 23:18:35 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
cc: Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, viro@zeniv.linux.org.uk,
        davej@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
In-Reply-To: <201203302105.52987.arnd@arndb.de>
Message-ID: <alpine.LFD.2.02.1203302318100.2542@ionos>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com> <20120330204235.GA883@kroah.com> <alpine.LFD.2.02.1203302247130.2542@ionos> <201203302105.52987.arnd@arndb.de>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 30 Mar 2012, Arnd Bergmann wrote:

> On Friday 30 March 2012, Thomas Gleixner wrote:
> > I think so. This is an interface to inject stuff into dmesg. Limiting
> > that to a reasonable size makes sense. We can probably limit it to
> > something small like 1024, but I don't know about the "ideas" of those
> > folks who think that it's a great idea to do it at all.
> 
> I guess a page would be a reasonable size, similar to what we do for
> sysfs. 

Fine with me.
