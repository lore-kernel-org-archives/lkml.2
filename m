Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab0KAKK0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 06:10:26 -0400
Received: from mail.sysgo.com ([195.145.229.155]:39876 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752285Ab0KAKKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 06:10:23 -0400
Date: Mon, 1 Nov 2010 11:10:12 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org
Subject: Re: carl9170 disconnects under load
Message-ID: <20101101101012.GB3391@pma.sysgo.com>
References: <20101026104811.GA11357@pma.sysgo.com>
 <20101101093140.GA2766@pma.sysgo.com>
 <20101101094649.GA3391@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101101094649.GA3391@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2010-11-01 10:46:49, Pavel Machek wrote:
> Hi!
> 
> > > I'm testing driver from -wireless testing, cca 2.6.26-rc7.
> > > 
> > > It seems to work (up to 802.11n speeds -- I've seen iwconfig claiming
> > > 121 MB/sec), but disconnects rather quickly when under load:
> > > 
> > > telnet 192.168.1.3 chargen > /dev/null
> > > 
> > > The machine is powerpc mpc5200b board, with OHCI driver -- it is not
> > > capable of USB2.0 speeds.
> > 
> > So I tried with different AP, one not capable of 802.11n speeds. It
> > fails in different way :-(. But this one is with my backport to
> > 2.6.34...
> 
> But it fails with wireless-testing tree, too :-(.
> 
> Linux mpc5200b 2.6.36-rc8-wl-pma-48197-gdcae733-dirty #43 Tue Oct 26
>  12:06:21 CEST 2010 ppc

It works "better" if I force AP to 1Mbps.... (Note that I have USB1.1
host only).
								Pavel

Registered led device: carl9170-phy1::assoc
usb 1-1: Atheros AR9170 is registered as 'phy1'
ieee80211 phy1: device now idle
ieee80211 phy1: device no longer idle - scanning
wlan0: authenticate with 00:11:95:05:30:d7 (try 1)
wlan0: authenticated
ieee80211 phy1: device now idle
ieee80211 phy1: device no longer idle - working
wlan0: associate with 00:11:95:05:30:d7 (try 1)
wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x421 status=0
aid=1)
wlan0: associated
ieee80211 phy1: Allocated STA 00:11:95:05:30:d7
ieee80211 phy1: Inserted STA 00:11:95:05:30:d7
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
ieee80211 phy1: FW: MAC RESET
-/bin/sh-3.00# 


