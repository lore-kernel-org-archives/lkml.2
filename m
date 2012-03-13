Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2CMIX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 04:23:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40686 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756412Ab2CMIXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 04:23:55 -0400
Date: Tue, 13 Mar 2012 09:23:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: simon@mungewell.org
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Bauer <michael@m-bauer.org>,
        Michal Maly <madcatxster@gmail.com>
Subject: Re: [PATCH 1/2] HID: hid-lg4ff add support for G27 LEDs
In-Reply-To: <03eaca06ba2629f55144daa5a386c74b.squirrel@mungewell.org>
Message-ID: <alpine.LNX.2.00.1203130922110.18356@pobox.suse.cz>
References: <1331565459-1892-1-git-send-email-simon@mungewell.org>    <alpine.LNX.2.00.1203121645050.18356@pobox.suse.cz>    <be2be8d04b58ce75fcba9798fcb4e4fa.squirrel@mungewell.org>    <20120312180738.GD14020@sirena.org.uk>   
 <3391c87c6cc142e1b50b73eb78e70dc8.squirrel@mungewell.org>    <20120312183235.GA28451@opensource.wolfsonmicro.com> <03eaca06ba2629f55144daa5a386c74b.squirrel@mungewell.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Mar 2012, simon@mungewell.org wrote:

> >> The LEDs on the G27 are very much more specific, mounted on the yoke of
> >> the gaming wheel.
> >
> >> Would this require the use/complexity of the LED subsystem?
> >
> > Well, it'd mean that applications that know how to drive LEDs will be
> > able to use the LEDs on this wheel with less per device knowledge which
> > seems like a useful thing and if someone wants to remap a LED to "new
> > mail" or whatever that'll be easier (nethack has the mailer daemon
> > deliver a scroll of mail!).
> 
> I'm not familiar with the LED subsystem, but my concerns would be that
> this would add a whole load of code to implement.

Not really, it's rather simple to use and as Mark said, it's a proper 
infrastructure to use here.

We already have HID drivers which are using this -- you can look at 
PicoLCD or Wiimote drivers and you'll see that it's indeed fairly simple.

> PS. I don't really care about email when screaming around Laguna Seca ;-)

:))

-- 
Jiri Kosina
SUSE Labs
