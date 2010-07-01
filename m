Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212Ab0GALjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 07:39:12 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:10081 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0GALjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 07:39:11 -0400
X-IronPort-AV: E=Sophos;i="4.53,519,1272844800"; 
   d="scan'208";a="690143"
Date: Thu, 1 Jul 2010 12:39:25 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jan Beulich <JBeulich@novell.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>, "mingo@elte.hu" <mingo@elte.hu>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       ksrinivasan <ksrinivasan@novell.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hpa@zytor.com" <hpa@zytor.com>
Subject: Re: [PATCH 2/4, v2] x86: enlightenment for ticket spin locks -  Xen
  implementation
In-Reply-To: <4C2C6680020000780000901E@vpn.id2.novell.com>
Message-ID: <alpine.DEB.2.00.1007011105430.30135@kaball-desktop>
References: <4C2A200F02000078000089E4@vpn.id2.novell.com> <4C2B1769.5090107@goop.org> <alpine.DEB.2.00.1006301647220.30135@kaball-desktop> <4C2C6680020000780000901E@vpn.id2.novell.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Jul 2010, Jan Beulich wrote:
> >>> On 30.06.10 at 17:57, Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> wrote:
> > On Wed, 30 Jun 2010, Jeremy Fitzhardinge wrote:
> >> On 06/29/2010 04:32 PM, Jan Beulich wrote:
> >> > Use the (alternative instructions based) callout hooks to the ticket
> >> > spinlock code to enlighten ticket locks when running fully virtualized
> >> > on Xen. Ultimately, this code might also be a candidate to be used
> >> > when running para-virtualized.
> >> >
> >> 
> >> I'm not sure what the gain is by making this independent of all the rest
> >> of the Xen support in the kernel.  Stefano is working on a series
> >> (posted a few times now) to add more paravirtual features for Xen HVM
> >> guests, and this work is conceptually very similar.
> > 
> > My series has been stable since a while now and contains all the basic
> > PV on HVM mechanisms you need, including parsing the cpuid and mapping
> > the shared info page.
> > 
> > Could you please rebase on my series (or at least the first two
> > patches), so that we don't conflict with each other?
> 
> I really don't want to make those patches depend on no upstream
> stuff (as I want it accepted upstream), and I'm not sure when your
> patch series is expected to be upstream. If that's going to be soon,
> I'd just re-base after it happened.
 
Given that the patch series has been tested and reviewed several times
by now, I don't expect big changes any more.
Therefore I hope it will be accepted as soon as possible (keeping in
mind that we are in RC3 right now).
