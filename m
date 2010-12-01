Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0LAMxo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 07:53:44 -0500
Received: from foo.stuge.se ([213.88.146.6]:36698 "HELO foo.stuge.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754985Ab0LAMxn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 07:53:43 -0500
Message-ID: <20101201125339.30270.qmail@stuge.se>
Date: Wed, 1 Dec 2010 13:53:39 +0100
From: Peter Stuge <peter@stuge.se>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, Jimmy RUBIN <jimmy.rubin@stericsson.com>,
        Dan JOHANSSON <dan.johansson@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: Re: [PATCH 09/10] MCDE: Add build files and bus
Mail-Followup-To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Greg KH <greg@kroah.com>, Jimmy RUBIN <jimmy.rubin@stericsson.com>,
	Dan JOHANSSON <dan.johansson@stericsson.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Marcus LORENTZON <marcus.xm.lorentzon@stericsson.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	dri-devel@lists.freedesktop.org,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <F45880696056844FA6A73F415B568C6953604E802E@EXDCVYMBSTM006.EQ1STM.local> <201011261224.59490.arnd@arndb.de> <AANLkTinCYdb8p4-H+Aki-z+i7ZL2ETwGJdDxOQ4XpBJ+@mail.gmail.com> <201011301621.48140.arnd@arndb.de> <20101130184049.GC8521@n2100.arm.linux.org.uk> <20101130184834.GA16055@kroah.com> <20101130220550.GD8521@n2100.arm.linux.org.uk> <20101130230533.GA11342@kroah.com> <20101130234215.GE8521@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101130234215.GE8521@n2100.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> I feel it would be better to allow the current situation to continue.

I think this misses the point, and is somewhat redundant; I think
everyone knows that it is easiest to never change anything. But
then nothing improves.


> If we start telling people that they can't use statically declared
> devices without first having an alternative,

I would consider it early warning that the way things have been done
before will go away. And I would thus write drivers in a way that
demonstrates and includes that understanding.

The same problem exists in hardware products needing any kind of
longish lifetime. Deal with evolving components by having clean
and simple interfaces, and by not relying on a particular interface
very deep on either side of the edge. Simple I think.


//Peter
