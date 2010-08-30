Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756172Ab0H3R1e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 13:27:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59428 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755539Ab0H3R1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 13:27:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pauli Nieminen <suokkos@gmail.com>
Subject: Re: [Bug #16337] general protection fault: 0000 [#1] SMP
Date: Mon, 30 Aug 2010 19:26:35 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3-rjw+; KDE/4.4.4; x86_64; ; )
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
References: <c1_O4wHrlB.A.63.mbueMB@chimera> <4C7AF2C4.9040507@gmail.com> <AANLkTinzVmtWhhvuRNcKF1xKs+L=Lw0DT2osDxcbA6ze@mail.gmail.com>
In-Reply-To: <AANLkTinzVmtWhhvuRNcKF1xKs+L=Lw0DT2osDxcbA6ze@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008301926.35443.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 30, 2010, Pauli Nieminen wrote:
> On Mon, Aug 30, 2010 at 2:52 AM, Justin P. Mattock
> <justinmattock@gmail.com> wrote:
> > On 08/29/2010 04:13 PM, Rafael J. Wysocki wrote:
> >>
> >> This message has been generated automatically as a part of a report
> >> of regressions introduced between 2.6.34 and 2.6.35.
> >>
> >> The following bug entry is on the current list of known regressions
> >> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> >> be listed and let the tracking team know (either way).
> >>
> >>
> >> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16337
> >> Subject         : general protection fault: 0000 [#1] SMP
> >> Submitter       : Justin P. Mattock<justinmattock@gmail.com>
> >> Date            : 2010-07-03 22:59 (58 days old)
> >> Message-ID      :<<4C2FC0E3.6050101@gmail.com>>
> >> References      : http://marc.info/?l=linux-kernel&m=127819798215589&w=2
> >>
> >>
> >>
> >
> >
> > only have seen this once..on the other hand (If im correct)maciej or pauli
> > where able to reproduce this.. I say leave open then go from there.
> >
> > Justin P. Mattock
> >
> 
> I was able to reproduce this with about 50% chance in boot. But that
> happened in a few rc (rc2-rc4 iirc) versions only. After that never
> again.

OK, I'm closing it now, please reopen if you see it again.

Rafael
