Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2LEVia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:38:30 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:45863 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751765Ab2LEVi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:38:29 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/AS6t/DgfAOxDBFzk3Mdt5IwViFJRpmvdAwexLZY
	bM1IKaHMot04E8
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [tpmdd-devel] [PATCH 1/1] TPM: STMicroelectronics ST33 I2C KERNEL 3.x.x
Date: Wed, 5 Dec 2012 22:39:02 +0100
User-Agent: KMail/1.13.7 (Linux/3.6.9; KDE/4.8.5; x86_64; ; )
Cc: Mathias LEBLANC <Mathias.LEBLANC@st.com>,
        "Jean-Luc BLANC" <jean-luc.blanc@st.com>,
        "Sirrix@jasper.es" <Sirrix@jasper.es>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rajiv Andrade <mail@srajiv.net>,
        "tpmdd-devel@lists.sourceforge.net" 
	<tpmdd-devel@lists.sourceforge.net>,
        Kent Yoder <shpedoikal@gmail.com>
References: <1353363322-2923-1-git-send-email-mathias.leblanc@st.com> <201212052120.47955.PeterHuewe@gmx.de> <20121205210048.GA6109@ennui.austin.ibm.com>
In-Reply-To: <20121205210048.GA6109@ennui.austin.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212052239.02710.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kent,

Am Mittwoch, 5. Dezember 2012, 22:00:48 schrieb Kent Yoder:
>   This is already at least v3 of the driver IIRC. And its not fully
> committed at all, its just in a staging tree. I can blow it away at any
> time if we find problems.
> 
>   Not a problem. usually I'd attach any updates I planned to commit for
> public review, then if anything wasn't made public before I issue my
> pull request to send them to security-next, I'd append the full diff to
> the pull request at that time. Either way, all changes will hit a list
> at some point in time.
Ok - great ;) maybe my I got the 'planning on pushing'  wrong.


> > I thought the Mathias has changed the naming of the files? I don't see
> > that in your commit.
> 
>   Good catch, this is the kind of review I was asking for. :-)

Hehe. Glad to hear.
You know I care for the tpm subsystem ;)

> 
> > The version you committed to that branch still has some of the items of
> > my first review. (e.g.
> > 
> >  * This program is free software; you can redistribute it and/or modify
> > 
> > * it under the terms of the GNU General Public License as published by
> > * the Free Software Foundation; either version 2 of the License, or
> > * (at your option) any later version.)
> > 
> > -> The (possible) GPL v3 clause has to go away for the kernel, but I'm
> > not a lawyer.
> 
>   A GPLv3 clause would say "v3 or any later version". This should be
> fine.

Hmm, okay. 
I just googled for it on lkml, there are some files and drivers.
So I guess it's okay - sorry for the noise.
But I'm not a lawyer, personally I'd go for GPLv2 only but that's my personal 
opinion. 


Thanks,
Peter


