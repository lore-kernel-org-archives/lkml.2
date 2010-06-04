Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab0FDQc3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 12:32:29 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:50843 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750880Ab0FDQc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 12:32:28 -0400
Date: Fri, 4 Jun 2010 18:32:18 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: linville@tuxdriver.com
Cc: reinette.chatre@intel.com, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: recalculate average tpt if not current
Message-ID: <20100604163218.GA28003@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi John,

http://marc.info/?l=linux-wireless&m=127317062320707&w=2 :
> > > The BUG_ON was introduced by:
> > > commit 3110bef78cb4282c58245bc8fd6d95d9ccb19749
> > > Author: Guy Cohen <guy.cohen@intel.com>
> > > Date:   Tue Sep 9 10:54:54 2008 +0800
> > > 
> > >     iwlwifi: Added support for 3 antennas
> > > 
> > > ... the portion adding the BUG_ON is reverted since we are encountering the error
> > > and BUG_ON was created with assumption that error is not encountered.
> > > 
> > > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > > ---
> > 
> > I noticed this patch in your wireless-next-2.6 pull request. Since it is
> > addressing a system hang issue, could it perhaps be included in
> > wireless-2.6 also? I should have included the bug report reference for
> > this purpose, sorry ... it is
> > https://bugzilla.redhat.com/show_bug.cgi?id=588021
> 
> I didn't send it that way because a) that code has been there for a
> really long time; and b) the reporter couldn't reliably reproduce
> the bug and therefore can't reliably test the fix.  While I agree
> that the fix looks harmless, no update is zero-risk.
> 
> Can you reliably hit that code?  Has it been tested enough that we
> should risk holding-up 2.6.34's release for it?
I'm one of those _very reliably_ hitting this BUG. I can tell how 
annoying it is. I have to backport the patch w/ every kernel release
to be able to use the wireless link _at all_. So please consider
it as somewhat urgent to get the patch included. 

I'm still in contact w/ Reinette regularly to get those problems fixed.
It involves physically moving around the city for testing any modification
so this working is slowly processing as it takes every time an enormous 
amount of time to do so. Work in (slow) progress, but it's alive..
C.f. http://permalink.gmane.org/gmane.linux.kernel/992941

BTW, https://bugzilla.redhat.com/show_bug.cgi?id=588021 this isn't fixed.
Maybe RH did fix it. kernel.org sources haven't. This is a blocker ever 
since.

  Cheers,

      Nils


