Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2LOQSb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 11:18:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373Ab2LOQSa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 11:18:30 -0500
Date: Sat, 15 Dec 2012 11:17:34 -0500
From: Dave Jones <davej@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: WARNING: at drivers/tty/tty_buffer.c:476
 flush_to_ldisc+0x1de/0x1f0()
Message-ID: <20121215161734.GA6218@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jiri Slaby <jslaby@suse.cz>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@linux.intel.com>
References: <20121212030124.GA10828@redhat.com>
 <20121215022918.GC21333@kroah.com>
 <1355543596.3837.10.camel@thor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355543596.3837.10.camel@thor>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 10:53:16PM -0500, Peter Hurley wrote:
 > On Fri, 2012-12-14 at 18:29 -0800, Greg Kroah-Hartman wrote:
 > > On Tue, Dec 11, 2012 at 10:01:24PM -0500, Dave Jones wrote:
 > > > Fuzz-testing fallout from post 3.7 tree as of commit 414a6750e59b0b687034764c464e9ddecac0f7a6
 > > > 
 > > > [ 2181.230579] ------------[ cut here ]------------
 > > > [ 2181.231277] WARNING: at drivers/tty/tty_buffer.c:476 flush_to_ldisc+0x1de/0x1f0()
 > > > [ 2181.232358] Hardware name: GA-MA78GM-S2H
 > > > [ 2181.232925] tty is NULL
 > 
 > Dave, how do you have your trinity command line + kvm configured? I had
 > to write a test jig to get this to happen but I'd prefer to reproduce it
 > in trinity.
 
no special params, though te first time I saw this it 
happened quickly as you see from the timestamp.
Yesterday I hit it a second time after fuzzing for
the better psrt of a day.

	Dave


