Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751856Ab0DUFBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 01:01:31 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53825 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab0DUFB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 01:01:29 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [Bug #15672] KVM bug, git bisected
Date: Wed, 21 Apr 2010 07:02:02 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc4-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Kent Overstreet <kent.overstreet@gmail.com>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <4BCE188A.1060408@redhat.com> <4BCE72D6.6010809@redhat.com>
In-Reply-To: <4BCE72D6.6010809@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201004210702.02129.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 April 2010, Rik van Riel wrote:
> On 04/20/2010 05:11 PM, Rik van Riel wrote:
> > On 04/19/2010 11:19 PM, Rafael J. Wysocki wrote:
> >> This message has been generated automatically as a part of a summary
> >> report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.33. Please verify if it still should be listed and let the
> >> tracking team
> >> know (either way).
> >>
> >>
> >> Bug-Entry : http://bugzilla.kernel.org/show_bug.cgi?id=15672
> >> Subject : KVM bug, git bisected
> >> Submitter : Kent Overstreet<kent.overstreet@gmail.com>
> >> Date : 2010-03-27 12:43 (24 days old)
> >> First-Bad-Commit:
> >> http://kernel.org/git/linus/5beb49305251e5669852ed541e8e2f2f7696c53e
> >> Message-ID :<4BADFD74.8060904@gmail.com>
> >> References : http://marc.info/?l=linux-kernel&m=126969385121711&w=2
> >
> > Should be fixed by commit ea90002b0fa7bdee86ec22eba1d951f30bf043a6
> 
> Never mind me - this is a harmless (but loud) overflow
> of PREEMPT_BITS in the preempt count.

OK, what am I supposed to do with this entry, then?  Close?

Rafael
