Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2CMVY6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:24:58 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab2CMVY5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:24:57 -0400
Date: Tue, 13 Mar 2012 22:24:55 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: simon@mungewell.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
In-Reply-To: <ced1eb513cb4134634e89feab0db49ca.squirrel@mungewell.org>
Message-ID: <alpine.LNX.2.00.1203132224410.18356@pobox.suse.cz>
References: <ced1eb513cb4134634e89feab0db49ca.squirrel@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Mar 2012, simon@mungewell.org wrote:

> > Not really, it's rather simple to use and as Mark said, it's a proper
> infrastructure to use here.
> > We already have HID drivers which are using this -- you can look at
> PicoLCD or Wiimote drivers and you'll see that it's indeed fairly
> simple.
> 
> So _you_ say.... I'm getting an Oops when device attempts to init the LED
> subsytem. :-(
> --
> Mar 13 12:54:56 ubuntu kernel: [  458.639674] Call Trace:
> Mar 13 12:54:56 ubuntu kernel: [  458.641143]  [<c13498ed>] ?
> device_create+0x2d/0x30
> Mar 13 12:54:56 ubuntu kernel: [  458.641245]  [<c1439119>]
> led_classdev_register+0x99/0xf0
> Mar 13 12:54:56 ubuntu kernel: [  458.641306]  [<e0977311>]
> lg4ff_init+0x2a1/0x570 [hid_logitech]
> Mar 13 12:54:56 ubuntu kernel: [  458.641313]  [<e0975427>]
> lg_probe+0x147/0x2c0 [hid_logitech]
> --

Could you please post the full oops?

-- 
Jiri Kosina
SUSE Labs
