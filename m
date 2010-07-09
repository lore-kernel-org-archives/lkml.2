Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab0GIUz3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 16:55:29 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:33750 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab0GIUz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 16:55:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Hendry <andrew.hendry@gmail.com>
Subject: Re: [Bug #16175] 2.6.35-rc1 system oom, many processes killed but memory not free
Date: Fri, 9 Jul 2010 22:54:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc4; KDE/4.4.4; x86_64; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
References: <-IGZ64uxA6G.A.P0H.bLmNMB@chimera> <20100709115010.CD72.A69D9226@jp.fujitsu.com> <AANLkTine2GbsnGfqZLzgDq2AWmAPpHqjDUugumpX2Ymv@mail.gmail.com>
In-Reply-To: <AANLkTine2GbsnGfqZLzgDq2AWmAPpHqjDUugumpX2Ymv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007092254.09736.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 09, 2010, Andrew Hendry wrote:
> Yes this one can be closed, it was ramdisk too big.
> 
> On Fri, Jul 9, 2010 at 12:53 PM, KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
> >> This message has been generated automatically as a part of a summary report
> >> of recent regressions.
> >>
> >> The following bug entry is on the current list of known regressions
> >> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> >> know (either way).
> >>
> >>
> >> Bug-Entry     : http://bugzilla.kernel.org/show_bug.cgi?id=16175
> >> Subject               : 2.6.35-rc1 system oom, many processes killed but memory not free
> >> Submitter     : andrew hendry <andrew.hendry@gmail.com>
> >> Date          : 2010-06-05 0:46 (34 days old)
> >> Message-ID    : <AANLkTim7CiW-yfugZUAHZCqLvXKgt9CwolCvbLGdCLAk@mail.gmail.com>
> >> References    : http://marc.info/?l=linux-kernel&m=127569877714937&w=2
> >
> > Andrew, I think this ticket can be closed, right?
> >
> > Rafael, can you please see following discussion?
> >
> > http://marc.info/?l=linux-kernel&m=127744262109629&w=2

Thanks for the update, bug closed.

Rafael
