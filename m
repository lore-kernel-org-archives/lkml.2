Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1EPOVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:21:22 -0400
Received: from cantor.suse.de ([195.135.220.2]:55103 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755500Ab1EPOVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:21:21 -0400
Date: Mon, 16 May 2011 16:21:18 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arun Sharma <asharma@fb.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kbuild@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add $KERNELRELEASE to firmware install path
Message-ID: <20110516142118.GM13293@sepie.suse.cz>
References: <20110505173939.GA20575@dev1756.snc6.facebook.com>
 <4DC3CA39.30806@suse.cz>
 <1304677113.20656.2.camel@i7.infradead.org>
 <20110506184438.GA30417@dev1756.snc6.facebook.com>
 <1304708557.20656.49.camel@i7.infradead.org>
 <20110506223727.GA29011@dev1756.snc6.facebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110506223727.GA29011@dev1756.snc6.facebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 06, 2011 at 03:37:27PM -0700, Arun Sharma wrote:
> On Fri, May 06, 2011 at 08:02:36PM +0100, David Woodhouse wrote:
> > On Fri, 2011-05-06 at 11:44 -0700, Arun Sharma wrote:
> > > 
> > > Without this change, if you have two kernel rpms/debs from different
> > > kernel versions installed, they'll result in a namespace conflict
> > > (rpm/deb install will fail), which gets resolved by this patch. 
> > 
> > The packages are broken then. They shouldn't include *any* files
> > in /lib/firmware.
> > 
> > Fix *that*, and the problem goes away.
> 
> Sounds good.
> 
> Michal: Should I send you a patch that drops /lib/firmware?

make deb-pkg generates a separate package with the firmware files. I
would suggest we do the same for rpm.

Michal
