Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab0HIRSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 13:18:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:60743 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0HIRSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 13:18:10 -0400
Subject: Re: linux-next: Tree for August 4 (olpc_battery)
From: David Woodhouse <dwmw2@infradead.org>
To: Randy Dunlap <randy.dunlap@oracle.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Andres Salomon <dilinger@collabora.co.uk>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100809093925.1ff3dc11.randy.dunlap@oracle.com>
References: <20100804151035.14678528.sfr@canb.auug.org.au>
	 <20100804094755.e0377eb0.randy.dunlap@oracle.com>
	 <20100809093925.1ff3dc11.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Aug 2010 18:17:52 +0100
Message-ID: <1281374272.7143.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-09 at 09:39 -0700, Randy Dunlap wrote:
> On Wed, 4 Aug 2010 09:47:55 -0700 Randy Dunlap wrote:
> 
> > On Wed, 4 Aug 2010 15:10:35 +1000 Stephen Rothwell wrote:
> > 
> > > Hi all,
> > > 
> > > As the merge window is open, please do not add 2.6.27 material to your
> > > linux-next included trees until after 2.6.36-rc1.
> > > 
> > > Changes since 20100803:
> > 
> > 
> > drivers/power/olpc_battery.c:387: error: unknown field 'owner' specified in initializer
> > drivers/power/olpc_battery.c:387: warning: excess elements in struct initializer
> > drivers/power/olpc_battery.c:387: warning: (near initialization for 'olpc_bat_eeprom.attr')
> > 
> > 
> > The .owner field has been dropped from the attr struct.
> 
> 
> Build still fails in linux-next 20100809.

Anton, please pull from git://git.infradead.org/~dwmw2/battery-2.6.git
(or I can just push it, but I figured I'd ask first).

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

