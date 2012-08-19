Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752358Ab2HSGOv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 02:14:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54478 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab2HSGOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 02:14:48 -0400
Date: Sat, 18 Aug 2012 23:14:43 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Perches <joe@perches.com>, Jim Cromie <jim.cromie@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Jason Baron <jbaron@redhat.com>
Subject: Re: [bisected] Driver core fixes for 3.6-rc3 regression
Message-ID: <20120819061443.GB1971@kroah.com>
References: <20120817171354.GA14046@kroah.com>
 <20120818060934.GA255@x4>
 <20120818163401.GA2013@kroah.com>
 <1345315025.10014.15.camel@joe2Laptop>
 <20120818185528.GA250@x4>
 <CA+55aFw48y=bZQq12-ySBiDT=ef6Yuq=eh6HLo6TGqyEK2kPkw@mail.gmail.com>
 <20120818193221.GB250@x4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120818193221.GB250@x4>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 18, 2012 at 09:32:21PM +0200, Markus Trippelsdorf wrote:
> On 2012.08.18 at 12:24 -0700, Linus Torvalds wrote:
> > On Sat, Aug 18, 2012 at 11:55 AM, Markus Trippelsdorf
> > <markus@trippelsdorf.de> wrote:
> > >
> > > IOW:
> > 
> > Ack, that looks about right. Does that simple patch fix the issue for
> > you?
> 
> Yes. Everything is fine again with this patch applied.

Huh?  I still see the dmesg output being split, and the ^0A characters
in the output log with this patch applied.

What do you see?

greg k-h
