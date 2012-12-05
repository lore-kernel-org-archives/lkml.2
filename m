Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767Ab2LEVCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:02:47 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:38516 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752446Ab2LEVCp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:02:45 -0500
Date: Wed, 5 Dec 2012 15:00:48 -0600
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Peter =?iso-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        Jean-Luc BLANC <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <shpedoikal@gmail.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C
 KERNEL 3.x.x
Message-ID: <20121205210048.GA6109@ennui.austin.ibm.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com>
 <20121205174527.GF21050@ennui.austin.ibm.com>
 <20121205180720.GG21050@ennui.austin.ibm.com>
 <201212052120.47955.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201212052120.47955.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120521-7182-0000-0000-0000038F4163
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 09:20:47PM +0100, Peter Hüwe wrote:
> Hi Kent,
> > 
> >   Heh, duh, well of course it is. I've now staged everything I'm
> > planning on pushing at:
> > 
> > git://github.com/shpedoikal/linux.git tpmdd-12-05-12
> > 
> > Please test and let me know if I missed anything.
> > 
> > Thanks,
> > Kent
> > 
> > > Kent
> > > 
> 
> (I'm still writing this on behalf of myself ;)
> 
> <pedantic mode on - please don't take it personally>
> While I really appreciate you helping Mathias out here, I'm not so sure 
> whether an offlist discussion of a driver submission is a really good idea. 
> I did not see any v2 / improvements on list and now it's commited (?!)

  This is already at least v3 of the driver IIRC. And its not fully
committed at all, its just in a staging tree. I can blow it away at any
time if we find problems.

> There's no need to argue here, I'm fine with this,
> but I'd highly appreciate if at least the result is published again in the 
> future on the mailing list, for proper review. 

  Not a problem. usually I'd attach any updates I planned to commit for
public review, then if anything wasn't made public before I issue my
pull request to send them to security-next, I'd append the full diff to
the pull request at that time. Either way, all changes will hit a list
at some point in time.

> If the mailfilter got the mails I apologize.
> <pedantic mode off>
> 
> Can you perhaps post the message to the list, so a proper review is possible?
> 
> I thought the Mathias has changed the naming of the files? I don't see that in 
> your commit.

  Good catch, this is the kind of review I was asking for. :-)

> 
> The version you committed to that branch still has some of the items of my 
> first review. (e.g.
>  * This program is free software; you can redistribute it and/or modify
> * it under the terms of the GNU General Public License as published by
> * the Free Software Foundation; either version 2 of the License, or
> * (at your option) any later version.)
> 
> -> The (possible) GPL v3 clause has to go away for the kernel, but I'm not a 
> lawyer.

  A GPLv3 clause would say "v3 or any later version". This should be
fine.

Kent

> 
> 
> Thanks,
> Peter
> 

