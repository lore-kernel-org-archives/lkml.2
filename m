Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537Ab1EZVa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:30:27 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45789 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998Ab1EZVa0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:30:26 -0400
Date: Thu, 26 May 2011 14:30:06 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Sjur =?ISO-8859-1?Q?Br=E6ndeland?= <sjurbren@gmail.com>
Cc: balbi@ti.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        netdev <netdev@vger.kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, gregkh@suse.de
Subject: Re: linux-next: Tree for May 26 (drivers/net/caif)
Message-Id: <20110526143006.2d1ef9f7.randy.dunlap@oracle.com>
In-Reply-To: <BANLkTikik8+f1D4D_Dv_rFK=QQjdce9rwg@mail.gmail.com>
References: <20110526163941.7dfcad1a.sfr@canb.auug.org.au>
	<20110526120702.fac24de0.randy.dunlap@oracle.com>
	<BANLkTikik8+f1D4D_Dv_rFK=QQjdce9rwg@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DDEC669.00D9:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 May 2011 23:15:34 +0200 Sjur Brændeland wrote:

> Hi Randy,
> 
> [Randy]
> > (not new)
> >
> > drivers/net/caif/caif_serial.c:194: warning: 'return' with no value, in function returning non-void
> > drivers/net/caif/caif_serial.c:202: warning: 'return' with no value, in function returning non-void
> >
> >
> > I'm curious:  how do warnings like this get overlooked?
> > too much noise in the build messages?  or it wasn't overlooked, just ignored?
> 
> The patch introducing this problem is "tty: make receive_buf()
> return the amout of bytes received" by Felipe Balbi <balbi@ti.com>.
> It seems that this patch has been posted to linux-serial and not to
> the netdev list or the gits net-next-2.6 or net-2.6 that I follow.
> It's probably no excuse, but this problem is news to me.

I see.  Thanks for the explanation.

> Should I post a patch on linux-next anyway for this issue?

You or Felipe should, but he recently sent this note to the USB
mailing list:

"I'll be away until 31st of May on a business travel. Don't expect me to
look into patches during that period."

so it looks like it would better for you to do it, please.

thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
