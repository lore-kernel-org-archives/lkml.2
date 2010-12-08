Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab0LHUoK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 15:44:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:38761 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756257Ab0LHUoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 15:44:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: [Bug #22782] 2.6.36: general protection fault during lockfs lockspace removal
Date: Wed, 8 Dec 2010 21:43:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "nik@linuxbox.cz" <nik@linuxbox.cz>
References: <jyQ21do2hOF.A.qwD.m_--MB@chimera> <z3LGq_ncuOB.A.J8D.GA_-MB@chimera> <20101208051742.GA2145@nik-comp.lan>
In-Reply-To: <20101208051742.GA2145@nik-comp.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201012082143.20254.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 08, 2010, Nikola Ciprich wrote:
> AFAIK the problem hasn't been fixed yet..
> n.
> 
> On Sun, Dec 05, 2010 at 09:34:33PM +0100, Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of regressions introduced between 2.6.35 and 2.6.36.
> > 
> > The following bug entry is on the current list of known regressions
> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> > be listed and let the tracking team know (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22782
> > Subject		: 2.6.36: general protection fault during lockfs lockspace removal
> > Submitter	: nik@linuxbox.cz <nik@linuxbox.cz>
> > Date		: 2010-11-12 12:05 (24 days old)

Thanks for the update.

Rafael
