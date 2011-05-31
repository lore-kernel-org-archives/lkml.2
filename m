Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab1EaAAZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 20:00:25 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41556 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750818Ab1EaAAY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 20:00:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: linux-next: Tree for May 30 (apm)
Date: Tue, 31 May 2011 02:00:51 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org, x86@kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
References: <20110530133531.847630f2.sfr@canb.auug.org.au> <20110530091045.40201b95.randy.dunlap@oracle.com>
In-Reply-To: <20110530091045.40201b95.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201105310200.51930.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, May 30, 2011, Randy Dunlap wrote:
> On Mon, 30 May 2011 13:35:31 +1000 Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20110527:
> > 
> > Linus' tree still has its build failure for which I reverted a commit.
> 
> 
> 2 randconfigs on i386 failed with:
> ERROR: "pm_idle" [arch/x86/kernel/apm.ko] undefined!
> ERROR: "default_idle" [arch/x86/kernel/apm.ko] undefined!

That appears to be a fallout of the changes that went in through
the Len's idle tree.

Thanks,
Rafael
