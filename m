Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410Ab1EIPZz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 11:25:55 -0400
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:28435 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752097Ab1EIPZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 11:25:54 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 98.234.237.12
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19Q6k6P4oWdxMsbVv4vNSc+
Date: Mon, 9 May 2011 08:25:47 -0700
From: Tony Lindgren <tony@atomide.com>
To: Mike Rapoport <mike.rapoport@gmail.com>
Cc: Colin Cross <ccross@google.com>, Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>,
        Martin Persson <martin.persson@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Erik Gilling <konkers@google.com>
Subject: Re: [PATCH 1/4] drivers: create a pinmux subsystem
Message-ID: <20110509152547.GD11410@atomide.com>
References: <1304363786-30376-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF0497F1B201@HQMAIL01.nvidia.com>
 <BANLkTimKU-=GXzrn8=MQn-GAmKHOvKmuNQ@mail.gmail.com>
 <20110504092219.GW2092@atomide.com>
 <BANLkTin9-aKZjEGdBeZqDwHwADXCYERErg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTin9-aKZjEGdBeZqDwHwADXCYERErg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mike Rapoport <mike.rapoport@gmail.com> [110507 12:03]:
> On Wed, May 4, 2011 at 12:22 PM, Tony Lindgren <tony@atomide.com> wrote:
> > * Colin Cross <ccross@google.com> [110502 14:26]:
> >> On Mon, May 2, 2011 at 1:52 PM, Stephen Warren <swarren@nvidia.com> wrote:
> >>
> >> * Drive strength is also controlled through groups of pins, but
> >> different groups than pinmux.  Most of the drive strength groups are
> >> collections of pad mux groups, but there are a few pins that are in
> >> the same pad mux group but a different drive strength group.
> >> * Setting a pin as a GPIO overrides its group's mux setting, except
> >> for the group's tristate.  You must untristate the entire group to use
> >> a single pin as a GPIO.
> >> * Each group has a "safe mode", but which mux id to select to enter
> >> the safe mode is completely random.
> >
> > Just posted something in this thread regarding using standard data and
> > standard read and write functions, then allow setting platform specific
> > custom flags as needed. Care to see if that works for you too?
> 
> Tegra does not allow pin muxing on the pin by pin basis. And,
> registers that define mux config differ from those that define flags
> (pull, driver strength, safe mode etc).

Hmm well the separate config register could be added easily. But the
grouping of pins might be tricky then :)

Tony
