Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2IFKdN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 06:33:13 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:33028 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753369Ab2IFKdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 06:33:10 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ai8FAB57SFBtggBP/2dsb2JhbABFhgaxXIM7gQiCIAEBBSMzIxALGAICJgICFCUEIIgkp26TAoEhiXCFMzJgA5VYkBuCZYFf
Date: Thu, 6 Sep 2012 12:33:13 +0200
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Fabio Baltieri <fabio.baltieri@gmail.com>
Cc: Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>
Subject: Re: [PATCH can-next v6] can: add tx/rx LED trigger support
Message-ID: <20120906103248.GA36903@macbook.local>
Mail-Followup-To: Fabio Baltieri <fabio.baltieri@gmail.com>,
	Oliver Hartkopp <socketcan@hartkopp.net>,
	Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Wolfgang Grandegger <wg@grandegger.com>
References: <20120824051016.GB1718@vandijck-laurijssen.be>
 <50376550.4020501@pengutronix.de>
 <20120824124248.GA422@vandijck-laurijssen.be>
 <20120824220142.GA1470@gmail.com>
 <5044A547.2010603@pengutronix.de>
 <20120903181335.GA415@vandijck-laurijssen.be>
 <20120903182925.GA28766@gmail.com>
 <50451919.20205@hartkopp.net>
 <20120904071128.GB416@vandijck-laurijssen.be>
 <20120904201553.GA29478@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120904201553.GA29478@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 04, 2012 at 10:15:53PM +0200, Fabio Baltieri wrote:
> On Tue, Sep 04, 2012 at 09:11:28AM +0200, Kurt Van Dijck wrote:
> > On Mon, Sep 03, 2012 at 10:54:49PM +0200, Oliver Hartkopp wrote:
> > > On 03.09.2012 20:29, Fabio Baltieri wrote:
> > > 
> > > 
[...]
> > > The name of the device can only be changed when the interface is down.
> > > Is it possible to put some scripting around it to detach and attach the leds
> > > to the interfaces on ifup/ifdown triggers?
> > 
> > Are the led triggers available for using while the netdev is down then?
> 
> Sure!  On embedded systems triggers are usually attached to actual LEDs
> at probe time using default_trigger field of struct led_classdev, and
> that can be specified both in machine files or in device tree.

I also think that led triggers should be available.
I asked the question because detach & attach leds to interfaces would
indeed break that.

btw, I tried to send a patch tuesday (my first $ git send-email) using
netdev notifiers: did you receive it, and what do you think of it?

Kurt
