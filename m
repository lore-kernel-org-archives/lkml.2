Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab0H3J1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 05:27:18 -0400
Received: from plane.gmane.org ([80.91.229.3]:55374 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739Ab0H3J1R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 05:27:17 -0400
Date: Mon, 30 Aug 2010 11:27:07 +0200
From: Florian Mickler <florian@mickler.org>
To: Torsten Kaiser 
	<public-just.for.lkml-gM/Ye1E23mwN+BqQ9rBEUg@plane.gmane.org>
Newsgroups: gmane.linux.kernel.kernel-testers,gmane.linux.kernel
Cc: "Rafael J. Wysocki" <public-rjw-KKrjLPT3xs0@plane.gmane.org>,
        Linux Kernel Mailing List 
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Kernel Testers List 
	<public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@plane.gmane.org>,
        Maciej Rutecki 
	<public-maciej.rutecki-Re5JQEeQqe8AvxtiuMwx3w@plane.gmane.org>
Subject: Re: [Bug #17041] 2.6.36-rc1 hangs during XFS barrier test for /
Message-ID: <20100830112707.4008b8af@schatten.dmk.lab>
In-Reply-To: <AANLkTikzDgHsPsUQMdb87R8dG61CBBekxBfhbuguLEPX@mail.gmail.com>
References: <4LwrqITm-eJ.A.r8G.eFueMB@chimera>
	<4AUWBNzTkbD.A.FI.7FueMB@chimera>
	<AANLkTikzDgHsPsUQMdb87R8dG61CBBekxBfhbuguLEPX@mail.gmail.com>
X-Newsreader: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 30 Aug 2010 06:36:47 +0200
Torsten Kaiser <just.for.lkml-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
wrote:

> On Mon, Aug 30, 2010 at 12:36 AM, Rafael J. Wysocki <rjw-KKrjLPT3xs0@public.gmane.org> wrote:
> > This message has been generated automatically as a part of a summary report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.35.  Please verify if it still should be listed and let the tracking team
> > know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=17041
> > Subject         : 2.6.36-rc1 hangs during XFS barrier test for /
> > Submitter       : Torsten Kaiser <just.for.lkml-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
> > Date            : 2010-08-20 (10 days old)
> > Message-ID      : <AANLkTim1PXibiY98GUdMj-UZLTav+n7GAnJ0Mjn6_5a3@mail.gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=128231691708710&w=2
> 
> As noted in comment #1 in this Bug, this was the same Bug as
> http://marc.info/?l=linux-kernel&m=128208298507451&w=2
> It is fixed as of 2.6.36-rc2.
> 
> You can close this Bug as fixed.
> 
> Thanks, Torsten

Done. 

Thx,
Flo

