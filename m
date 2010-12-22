Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab0LVAYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:24:10 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:42309 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0LVAYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:24:09 -0500
Date: Tue, 21 Dec 2010 17:24:07 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Prevent users from disabling tickless
Message-ID: <20101222002407.GM1263@parisc-linux.org>
References: <20101221233942.GL1263@parisc-linux.org> <201012220046.23759.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012220046.23759.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 12:46:23AM +0100, Rafael J. Wysocki wrote:
> On Wednesday, December 22, 2010, Matthew Wilcox wrote:
> > 
> > Disabling NO_HZ has a serious negative effect on performance -- an extra
> > 70us per I/O.  Prevent users from deselecting it.
> > 
> > Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> OTOH, it causes some systems to not work at all still.  Sadly.

It doesn't stop people from specifying nohz=off on the kernel command line.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
