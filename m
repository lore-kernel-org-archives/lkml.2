Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab0FETQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 15:16:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:37452 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab0FETQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 15:16:26 -0400
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 8)
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
       Florian Mickler <florian@mickler.org>,
       James Bottomley <James.Bottomley@suse.de>,
       Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>, tytso@mit.edu,
       LKML <linux-kernel@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       felipe.balbi@nokia.com, Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <201006052104.05324.rjw@sisk.pl>
References: <20100527222514.0a1710bf@lxorguk.ukuu.org.uk>
	 <20100531224732.2073828d@schatten.dmk.lab>
	 <AANLkTinPUNer7XhAqS4VSWhOxqjEjaHtr76EK5tzYYjJ@mail.gmail.com>
	 <201006052104.05324.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 05 Jun 2010 21:16:19 +0200
Message-ID: <1275765379.1645.532.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-06-05 at 21:04 +0200, Rafael J. Wysocki wrote:
> 
> > I have seen recent proposals that don't require changing the whole
> > user-space. That might actually be used by other players.
> 
> Sure, an approach benefitting more platforms than just Android would be better,
> but saying that the kernel shouldn't address the Android's specific needs as a
> rule if no one else has those needs too is quite too far reaching to me. 

Well, if the android people keep rejecting all sensible approaches to
power savings except their suspend blocker mess, then I don't see why we
should support their ill designed mess.

We should strive to provide an interface that can be used by all
interested parties to conserve power; if Android really is the only
possible user of the interface then I don't see any reason at all to
merge it, they might as well keep it in their private tree.



