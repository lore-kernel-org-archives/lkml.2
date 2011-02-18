Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab1BRQQh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 11:16:37 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:60014 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1BRQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 11:16:33 -0500
Date: Thu, 17 Feb 2011 18:40:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ryan Underwood <ryan.underwood@flightsafety.com>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc2: Uhhuh. NMI received for unknown reason 2d on CPU 0.
Message-ID: <20110218024055.GA2237@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <9F0C2539CB50A743894F8FCEEB1D569206F4A5@mx1.guavus.com>
 <loom.20110217T003826-785@post.gmane.org>
 <AANLkTikEMOxtTe7afmYsvyQkJi7j70TRX3cPPR0X=uQj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikEMOxtTe7afmYsvyQkJi7j70TRX3cPPR0X=uQj@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 10:59:43AM +0300, Cyrill Gorcunov wrote:
> On Thu, Feb 17, 2011 at 3:17 AM, Ryan Underwood
> <ryan.underwood@flightsafety.com> wrote:
> > Preeti Khurana <Preeti.Khurana <at> guavus.com> writes:
> >
> >>
> >> I am getting the similar issue as reported
> >> in https://lkml.org/lkml/2011/2/10/187
> >>
> >> Can someone tell me if the same issue  because I am getting the
> >> problem on Intel Xeon..
> >>
> >
> > I am seeing exactly the same problem (on 2.6.35 as Preeti reported originally)
> > on some Xeon servers but only with recently shipped BIOS revisions. The OS is
> > CentOS 5.5.
> >
> ...
> > I have not tried the following patches yet which seem to both be for spurious
> > NMI messages, not accompanied by system lockups:
> >
> > https://lkml.org/lkml/2011/2/16/106
> > https://lkml.org/lkml/2011/2/1/286
> >
> > Both nmi_watchdog=0 and pcie_aspm=off options do not solve the problem.
> >
> > I am not subscribed so please Cc me.

Given 2.6.35, has anyone tried applying the following patch?

	https://patchwork.kernel.org/patch/23985/

It turned out to resolve an otherwise mysterious RCU CPU stall warning
for someone running 2.6.36, IIRC.

							Thanx, Paul
