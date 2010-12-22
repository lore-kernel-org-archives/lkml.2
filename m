Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab0LVAih (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:38:37 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44442 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab0LVAig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:38:36 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Prevent users from disabling tickless
Date: Wed, 22 Dec 2010 01:38:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
References: <20101221233942.GL1263@parisc-linux.org> <201012220046.23759.rjw@sisk.pl> <20101222002407.GM1263@parisc-linux.org>
In-Reply-To: <20101222002407.GM1263@parisc-linux.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012220138.08105.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 22, 2010, Matthew Wilcox wrote:
> On Wed, Dec 22, 2010 at 12:46:23AM +0100, Rafael J. Wysocki wrote:
> > On Wednesday, December 22, 2010, Matthew Wilcox wrote:
> > > 
> > > Disabling NO_HZ has a serious negative effect on performance -- an extra
> > > 70us per I/O.  Prevent users from deselecting it.
> > > 
> > > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> > 
> > OTOH, it causes some systems to not work at all still.  Sadly.
> 
> It doesn't stop people from specifying nohz=off on the kernel command line.

Which still doesn't work for some people AFAICT.

Thanks,
Rafael
