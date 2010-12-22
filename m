Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0LVAgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 19:36:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:44429 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865Ab0LVAgh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 19:36:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: platform/i2c busses: pm runtime and system sleep
Date: Wed, 22 Dec 2010 01:35:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7+; KDE/4.4.4; x86_64; ; )
Cc: Rabin Vincent <rabin@rab.in>, stern@rowland.harvard.edu,
        linux-pm@lists.linux-foundation.org, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
References: <AANLkTinyDE3OxKup_aqsN8HJH_r5LcwkP17OtuMRpACx@mail.gmail.com> <201012202213.53902.rjw@sisk.pl> <20101221235127.GC10081@opensource.wolfsonmicro.com>
In-Reply-To: <20101221235127.GC10081@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201012220135.56766.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 22, 2010, Mark Brown wrote:
> On Mon, Dec 20, 2010 at 10:13:53PM +0100, Rafael J. Wysocki wrote:
> 
> > Well, the _solution_ is to get rid of the legacy stuff from those buses in the
> > first place.  Then, they'll just need to use the generic ops without any
> > trouble.
> 
> > What you're proposing is a workaround that people will use as an excuse for
> > not doing the right thing forever.
> 
> I hadn't actually realised that there was any urgency about removing the
> old APIs - I'd not really seen much work in that direction.  If the
> intention is to actively push people over to dev_pm_ops that does make a
> bit more sense.

There's no urgency strictly speaking, but there's a preference. :-)

I think it probably is the time to actually start pushing people into that,
because the legacy stuff has been causing too much pain recently.

Thanks,
Rafael
