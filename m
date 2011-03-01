Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757077Ab1CATUd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 14:20:33 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62932 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab1CATUc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 14:20:32 -0500
Date: Tue, 1 Mar 2011 11:19:22 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: linux-next: Tree for March 1 (staging/winbond)
Message-Id: <20110301111922.69b0d8c1.randy.dunlap@oracle.com>
In-Reply-To: <AANLkTimX0zvBEMxedXnhXiaxwEKHmm_Tu6fiZQkahZrC@mail.gmail.com>
References: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au>
	<20110301104924.071044ef.randy.dunlap@oracle.com>
	<AANLkTimX0zvBEMxedXnhXiaxwEKHmm_Tu6fiZQkahZrC@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4D6D46C6.01AD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Mar 2011 21:10:23 +0200 Pekka Enberg wrote:

> On Tue, Mar 1, 2011 at 8:49 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > On Tue, 1 Mar 2011 18:11:19 +1100 Stephen Rothwell wrote:
> >
> >> Hi all,
> >>
> >> Changes since 20110228:
> >
> >
> > commit ddee7e28e7d5e4ba2b8537c6a59b035745c250bb
> > Author: Pekka Enberg <penberg@kernel.org>
> > Date:   Sun Nov 28 23:00:01 2010 +0200
> >    Staging: w35und: Remove empty sysdef.h header
> >
> >
> > This header should not have been empty, since in
> >
> > commit 412dc7f368bf10a8049a8a4c41abbfd0108742e7
> > Author: Randy Dunlap <randy.dunlap@oracle.com>
> > Date:   Fri Nov 19 09:30:18 2010 -0800
> >    staging: fix winbond build, needs delay.h
> >
> > I added delay.h to it.  And now we have the same build
> > errors that I fixed last November:
> >
> > drivers/staging/winbond/phy_calibration.c:986: error: implicit declaration of function 'msleep'
> > drivers/staging/winbond/phy_calibration.c:1555: error: implicit declaration of function 'udelay'
> > drivers/staging/winbond/reg.c:893: error: implicit declaration of function 'msleep'
> > drivers/staging/winbond/reg.c:1169: error: implicit declaration of function 'udelay'
> 
> Strange. I didn't see the problem. We should add delay.h to
> phy_calibration.c and reg.c instead. Care to make a patch?
> --

No thanks, I'll let the staging people do that.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
