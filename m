Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706Ab0H3OYO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:24:14 -0400
Received: from plane.gmane.org ([80.91.229.3]:55558 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab0H3OYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:24:13 -0400
Date: Mon, 30 Aug 2010 16:21:50 +0200
From: Florian Mickler <florian@mickler.org>
To: Larry Finger 
	<public-Larry.Finger-tQ5ms3gMjBLk1uMJSBkQmQ@plane.gmane.org>
Newsgroups: gmane.linux.kernel.kernel-testers,gmane.linux.kernel
Cc: "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@plane.gmane.org>,
        Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Kernel Testers List 
	<public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Maciej Rutecki 
	<public-maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>,
        archman 
	<public-spermmail001-/E1597aS9LQAvxtiuMwx3w@plane.gmane.org>
Subject: Re: [Bug #16505] 2.6.34.2 breaks b43
Message-ID: <20100830162150.30a73403@schatten.dmk.lab>
In-Reply-To: <4C7AFE2C.1080204@lwfinger.net>
References: <c1_O4wHrlB.A.63.mbueMB@chimera>
	<ByD_7B96czP.A.h7B.DdueMB@chimera>
	<4C7AFE2C.1080204@lwfinger.net>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sun, 29 Aug 2010 19:41:16 -0500
Larry Finger <Larry.Finger-tQ5ms3gMjBLk1uMJSBkQmQ@public.gmane.org>
wrote:

> On 08/29/2010 06:13 PM, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.34 and 2.6.35.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=16505
> > Subject		: 2.6.34.2 breaks b43
> > Submitter	: archman <spermmail001-/E1597aS9LQAvxtiuMwx3w@public.gmane.org>
> > Date		: 2010-08-03 23:53 (27 days old)
> > Handled-By	: Larry Finger <Larry.Finger-tQ5ms3gMjBLk1uMJSBkQmQ@public.gmane.org>
> > Patch		: https://bugzilla.kernel.org/attachment.cgi?id=27335
> 
> This one was fixed in 2.6.34.3. Mainline was OK - only the patches to stable
> were affected. The bug should be closed.
> 
> Larry
> 

In the bugzilla entry someone mentioned that 2.6.32.y need this
too?

Cheers,
Flo

