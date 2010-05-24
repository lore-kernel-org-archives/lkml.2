Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932139Ab0EXSZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:25:54 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45560 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab0EXSZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:25:51 -0400
Date: Mon, 24 May 2010 20:26:03 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Russ Anderson <rja@sgi.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Luck, Tony" <tony.luck@intel.com>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       "Young, Brent" <brent.young@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Joe Perches <joe@perches.com>, Ingo Molnar <mingo@elte.hu>,
       "bluesmoke-devel@lists.sourceforge.net" 
	<bluesmoke-devel@lists.sourceforge.net>,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>
Subject: Re: Hardware Error Kernel Mini-Summit
Message-ID: <20100524182603.GA3429@gargoyle.fritz.box>
References: <4BF2C3D1.10009@redhat.com> <1274204560.17703.82.camel@Joe-Laptop.home> <20100518185305.GA23921@elte.hu> <987664A83D2D224EAE907B061CE93D53C61D1C57@orsmsx505.amr.corp.intel.com> <20100518191802.GG25224@aftab> <m1k4r0c0y7.fsf@fess.ebiederm.org> <20100518222832.GJ22675@basil.fritz.box> <m1wrv0zo9q.fsf@fess.ebiederm.org> <20100519090323.GA18073@basil.fritz.box> <20100524162124.GB7145@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100524162124.GB7145@sgi.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Having the infrastructure to automatically off-line pages
> is a good thing.  The details of where to set the predictive

It's already there with a modern mcelog in daemon mode 
and a recent kernel that supports soft offlining.

> threshold likely will be hardware specific (different DIMM
> types failing at different rates).  It needs to be adjustable.

The current default in mcelog is 10 corrected errors per 24h
per 4k page or 1 uncorrected error on the page (if your CPU
supports recovering from that).  It is on by default. 

You can configure it to be different if you want.

-Andi
