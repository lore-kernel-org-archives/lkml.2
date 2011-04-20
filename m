Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753910Ab1DTUis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 16:38:48 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39637 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1DTUiq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 16:38:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg KH <greg@kroah.com>, Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] driver core: syscore exports for modular APM
Date: Wed, 20 Apr 2011 22:39:10 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <20110419150641.644638d5.sfr@canb.auug.org.au> <20110419211741.GA19576@kroah.com> <201104200004.27331.rjw@sisk.pl>
In-Reply-To: <201104200004.27331.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104202239.10921.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, April 20, 2011, Rafael J. Wysocki wrote:
> On Tuesday, April 19, 2011, Greg KH wrote:
> > On Tue, Apr 19, 2011 at 08:35:46AM -0700, Randy Dunlap wrote:
> > > From: Randy Dunlap <randy.dunlap@oracle.com>
> > > 
> > > When CONFIG_APM=m, build fails with:
> > > 
> > > ERROR: "syscore_suspend" [arch/x86/kernel/apm.ko] undefined!
> > > ERROR: "syscore_resume" [arch/x86/kernel/apm.ko] undefined!
> > > 
> > > Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> > 
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > Rafael, care to send this to Linus?  Or do you want me to?
> 
> I will.  Or better I'll fold it into the patch, it hasn't been
> sent to Linus yet.

The problem should be fixed in today's linux-next.  Randy, can you confirm,
please?

Rafael
