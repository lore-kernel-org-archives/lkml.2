Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758059Ab1FFUuG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:50:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:1648 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757302Ab1FFUuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:50:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,327,1304319600"; 
   d="scan'208";a="10224425"
Date: Mon, 6 Jun 2011 22:50:00 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: Waldemar.Rymarkiewicz@tieto.com, arnd@arndb.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hthebaud@insidefr.com,
        matti.j.aaltonen@nokia.com, alan@lxorguk.ukuu.org.uk,
        Sebastian.Chlad@tieto.com
Subject: Re: [PATCH] NFC: Driver for Inside Secure MicroRead NFC chip
Message-ID: <20110606205000.GB2880@sortiz-mobl>
References: <1300444824-13713-1-git-send-email-waldemar.rymarkiewicz@tieto.com>
 <20110325142648.GC3879@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085E2375D@EXMB04.eu.tieto.com>
 <201103291305.02293.arnd@arndb.de>
 <20110331141650.GB2704@sortiz-mobl>
 <99B09243E1A5DA4898CDD8B7001114481085F0FE7C@EXMB04.eu.tieto.com>
 <20110331153010.GD2704@sortiz-mobl>
 <BANLkTimsZeqvSWj+kKWLSmFOQc70KWodcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimsZeqvSWj+kKWLSmFOQc70KWodcw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavan,

On Mon, Jun 06, 2011 at 03:22:01PM -0500, Pavan Savoy wrote:
> On Thu, Mar 31, 2011 at 9:30 AM, Samuel Ortiz <sameo@linux.intel.com> wrote:
> > On Thu, Mar 31, 2011 at 06:24:50PM +0300, Waldemar.Rymarkiewicz@tieto.com wrote:
> >> Hi Samuel,
> >>
> >> >That's the Bluetooth approach, and it works just fine as well.
> >> >However, the netlink option for sending commands and receiving
> >> >answers to/from a subsystem sounds more appropriate, at least to me.
> >>
> >> I haven't used netlink in practice, so just wondering why netlink. I assume, then, it's more suitable :)
> >>
> > Have a look at the wireless nl80211.c implementation. It's a good example for
> > that sort of usage.
> 
> So, why was the network interface 'ala eth0 or the netlink interface dropped?
The netlink interface was not dropped. See:
http://marc.info/?l=linux-wireless&m=130705125228073&w=2

> I saw these patches recently "NFC: add nfc subsystem core" - which
> seem to add just the device /dev/nfc - am I correct ?
No, the /dev/nfc interface is gone with this subsystem. Instead you will talk
to an AF_NFC socket, or to the NFC generic netlink socket for some NFC high
level commands and events. See:
http://marc.info/?l=linux-wireless&m=130705125728090&w=2

for more details.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
