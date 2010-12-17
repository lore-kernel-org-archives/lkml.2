Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab0LQNuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 08:50:25 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:35607 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754272Ab0LQNuY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 08:50:24 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Date: Fri, 17 Dec 2010 14:49:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc6+; KDE/4.4.4; x86_64; ; )
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com> <201012171425.07775.rjw@sisk.pl> <20101217133434.GH31453@rakim.wolfsonmicro.main>
In-Reply-To: <20101217133434.GH31453@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012171449.26082.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 17, 2010, Mark Brown wrote:
> On Fri, Dec 17, 2010 at 02:25:07PM +0100, Rafael J. Wysocki wrote:
> > On Friday, December 17, 2010, Mark Brown wrote:
> 
> > > It'd be really good if this could all be factored out into the PM core,
> > > we're going to have to do the same thing for at least SPI as well and
> > > possibly some other buses :/
> 
> > So how exactly the PM core is supposed to include those things?
> 
> > There certainly are other buses that don't want to do them.
> 
> By, for example, providing default implementations which the buses can
> use if they choose to.

OK, so we have generic_subsys_pm_ops.  Do we need anything beyond that?

Rafael
