Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab0IWPOA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 11:14:00 -0400
Received: from xenotime.net ([72.52.115.56]:56025 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750855Ab0IWPN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 11:13:59 -0400
Date: Thu, 23 Sep 2010 08:13:50 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Greg KH <greg@kroah.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Alan Cox <alan@linux.intel.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the tty tree
Message-Id: <20100923081350.e028c4ac.rdunlap@xenotime.net>
In-Reply-To: <20100923141433.GC31738@kroah.com>
References: <20100923142018.55019d59.sfr@canb.auug.org.au>
	<20100923141433.GC31738@kroah.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010 07:14:33 -0700 Greg KH wrote:

> On Thu, Sep 23, 2010 at 02:20:18PM +1000, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the tty tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> > 
> > drivers/char/ip2/ip2main.c:459: error: 'ip2_get_icount' undeclared here (not in a function)
> > 
> > Caused by commit 157be28e51ed476aa357c8718aaef4832f4da66b ("tty: icount
> > changeover for other main devices").
> > 
> > Please build test (especially the trivial "cut and paste" changes) ...
> > 
> > I have reverted that commit for today.
> 
> Ick, sorry about that.  Alan, care to send a fixup patch for this?


So developers and maintainers are not doing allmodconfig builds?
I can understand not doing randconfig builds.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
