Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759681Ab2CaBnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 21:43:19 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44048 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754575Ab2CaBnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 21:43:14 -0400
Message-ID: <1333158192.30088.0.camel@joe2Laptop>
Subject: Re: [PATCH] kmsg: Use vmalloc instead of kmalloc when writing
From: Joe Perches <joe@perches.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <levinsasha928@gmail.com>, viro@zeniv.linux.org.uk,
        davej@redhat.com, linux-kernel@vger.kernel.org
Date: Fri, 30 Mar 2012 18:43:12 -0700
In-Reply-To: <201203302105.52987.arnd@arndb.de>
References: <1333127067-2043-1-git-send-email-levinsasha928@gmail.com>
	 <20120330204235.GA883@kroah.com> <alpine.LFD.2.02.1203302247130.2542@ionos>
	 <201203302105.52987.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-03-30 at 21:05 +0000, Arnd Bergmann wrote:
> On Friday 30 March 2012, Thomas Gleixner wrote:
> > I think so. This is an interface to inject stuff into dmesg. Limiting
> > that to a reasonable size makes sense. We can probably limit it to
> > something small like 1024, but I don't know about the "ideas" of those
> > folks who think that it's a great idea to do it at all.

Per line dmesg output is limited to 1024 anyway.


