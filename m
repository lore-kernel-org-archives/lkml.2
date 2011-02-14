Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753926Ab1BNXfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:35:40 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:13040 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880Ab1BNXfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:35:38 -0500
Date: Tue, 15 Feb 2011 00:34:34 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: "Nicholas A. Bellinger" <nab@risingtidesystems.com>
cc: linux-kernel@vger.kernel.org, James Bottomley <James.Bottomley@suse.de>,
        trivial@kernel.org
Subject: Re: [PATCH][trivial] iSCSI HBA Transport, target: Fix duplicate
 include and typo in drivers/target/target_core_hba.c
In-Reply-To: <1297725651.29207.39.camel@haakon2.linux-iscsi.org>
Message-ID: <alpine.LNX.2.00.1102150030450.4530@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1102142355020.4530@swampdragon.chaosbits.net> <1297725651.29207.39.camel@haakon2.linux-iscsi.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Feb 2011, Nicholas A. Bellinger wrote:

> On Tue, 2011-02-15 at 00:02 +0100, Jesper Juhl wrote:
> > target/target_core_device.h is included twice in 
> > drivers/target/target_core_hba.c .  This patch removes the duplicate.
> > Also correct a typo: copntains --> contains .
> > 
> > Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> > ---
> > 
> > diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
> > index 4bbe820..8780ba8 100644
> > --- a/drivers/target/target_core_hba.c
> > +++ b/drivers/target/target_core_hba.c
> > @@ -1,7 +1,7 @@
> >  /*******************************************************************************
> >   * Filename:  target_core_hba.c
> >   *
> > - * This file copntains the iSCSI HBA Transport related functions.
> > + * This file contains the iSCSI HBA Transport related functions.
> >   *
> >   * Copyright (c) 2003, 2004, 2005 PyX Technologies, Inc.
> >   * Copyright (c) 2005, 2006, 2007 SBE, Inc.
> > @@ -38,7 +38,6 @@
> >  
> 
> Ok, I will be going through and updating the copyrights soon, and I will
> include this spelling correction.
> 

Ok. When you do that, how about removing the "* Filename:  " lines as 
well. To have a comment saying (for example) "* Filename:  target_core_hba.c" 
inside a file named "target_core_hba.c" is at best redundant and at worst 
incorrect if the file gets renamed but the comment not updated. In any 
case it serves little to no purpose that I can think of.


> >  #include <target/target_core_base.h>
> >  #include <target/target_core_device.h>
> > -#include <target/target_core_device.h>
> >  #include <target/target_core_tpg.h>
> >  #include <target/target_core_transport.h>
> >  
> 
> This extra include has been removed in lio-core-2.6.git, but has not
> made it to mainline just yet.
> 
Fair enough. The patch was against linux-next, so aparently it has not yet 
made it there either. No problem, I just only checked linux-next and 
Linus's tree. :)

-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Plain text mails only, please.
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html

