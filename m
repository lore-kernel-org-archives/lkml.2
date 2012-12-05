Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2LEUUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 15:20:20 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:34654 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752307Ab2LEUUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 15:20:18 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+3+7QyXx63u4Dymfkdoef+CG5KgFjFXUj3sXBe1t
	bHXEuL600uHMPh
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
Date: Wed, 5 Dec 2012 21:20:47 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.9; KDE/4.8.5; x86_64; ; )
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        "Jean-Luc BLANC" <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <shpedoikal@gmail.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com> <20121205174527.GF21050@ennui.austin.ibm.com> <20121205180720.GG21050@ennui.austin.ibm.com>
In-Reply-To: <20121205180720.GG21050@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212052120.47955.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,
> 
>   Heh, duh, well of course it is. I've now staged everything I'm
> planning on pushing at:
> 
> git://github.com/shpedoikal/linux.git tpmdd-12-05-12
> 
> Please test and let me know if I missed anything.
> 
> Thanks,
> Kent
> 
> > Kent
> > 

(I'm still writing this on behalf of myself ;)

<pedantic mode on - please don't take it personally>
While I really appreciate you helping Mathias out here, I'm not so sure 
whether an offlist discussion of a driver submission is a really good idea. 
I did not see any v2 / improvements on list and now it's commited (?!)

There's no need to argue here, I'm fine with this,
but I'd highly appreciate if at least the result is published again in the 
future on the mailing list, for proper review. 

If the mailfilter got the mails I apologize.
<pedantic mode off>

Can you perhaps post the message to the list, so a proper review is possible?

I thought the Mathias has changed the naming of the files? I don't see that in 
your commit.


The version you committed to that branch still has some of the items of my 
first review. (e.g.
 * This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.)

-> The (possible) GPL v3 clause has to go away for the kernel, but I'm not a 
lawyer.



Thanks,
Peter
