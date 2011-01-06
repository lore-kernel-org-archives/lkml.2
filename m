Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab1AFPkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:40:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36947 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243Ab1AFPkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:40:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Prasad Joshi <prasadjoshi124@gmail.com>
Subject: Re: [Bug #20332] [LogFS] [2.6.36-rc7] Kernel BUG at lib/btree.c:465!
Date: Thu, 6 Jan 2011 16:39:35 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera> <LbeBv-BNQpL.A.KT.IG8GNB@chimera> <AANLkTi=2PZ81T4_vV4RiXgxZB3PHzpEfEisEN-cO1jjg@mail.gmail.com>
In-Reply-To: <AANLkTi=2PZ81T4_vV4RiXgxZB3PHzpEfEisEN-cO1jjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101061639.35545.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, January 02, 2011, Prasad Joshi wrote:
> Hello,
> 
> I did not observe this bug with the latest kernel (2.6.37-rc8+).

Thanks, closed.

Rafael


> On Wed, Dec 29, 2010 at 11:21 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.35 and 2.6.36.
> >
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> >
> >
> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=20332
> > Subject         : [LogFS] [2.6.36-rc7] Kernel BUG at lib/btree.c:465!
> > Submitter       : Prasad Joshi <prasadjoshi124@gmail.com>
> > Date            : 2010-10-12 18:56 (79 days old)
> > Message-ID      : <AANLkTimAbCZNhLQ5nADUiAC+7JpAeJBEmjFwdxyZ-FxO@mail.gmail.com>
> > References      : http://marc.info/?l=linux-kernel&m=128690910501830&w=2
> >
> >
> >
> 
> 

