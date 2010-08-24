Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753278Ab0HXAtU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 20:49:20 -0400
Received: from [64.85.170.234] ([64.85.170.234]:38215 "EHLO mail.tomasu.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab0HXAtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 20:49:19 -0400
From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: ath5k problem with 2.6.35
Date: Mon, 23 Aug 2010 18:49:12 -0600
User-Agent: KMail/1.13.5 (Linux/2.6.35-trunk-amd64; KDE/4.4.5; x86_64; ; )
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201008220005.38969.tfjellstrom@strangesoft.net> <201008220153.41678.thomas@fjellstrom.ca> <20100823182903.GE2609@tuxdriver.com>
In-Reply-To: <20100823182903.GE2609@tuxdriver.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008231849.13144.thomas@fjellstrom.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On August 23, 2010, John W. Linville wrote:
> On Sun, Aug 22, 2010 at 01:53:41AM -0600, Thomas Fjellstrom wrote:
> > On August 22, 2010, Thomas Fjellstrom wrote:
> > > Hi, I'm running 2.6.35, and my wireless card fails to initialize
> > > properly
> > 
> > > on boot. I get the following messages in dmesg:
> > Probably important, but I missed a couple lines:
> > > [    0.866525] ath5k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) ->
> > > IRQ 17 [    0.866536] ath5k 0000:02:00.0: setting latency timer to 64
> > > [    0.866571] ath5k 0000:02:00.0: registered as 'phy0'
> > > [    1.358241] ath: EEPROM regdomain: 0x67
> > > [    1.358242] ath: EEPROM indicates we should expect a direct regpair
> > > map [    1.358245] ath: Country alpha2 being used: 00
> > > [    1.358247] ath: Regpair used: 0x67
> > > 
> >    [    1.360589] phy0: Failed to initialize wep: -2
> > > 
> > > [    1.372021] ath5k phy0: can't register ieee80211 hw
> > > [    1.372080] ath5k 0000:02:00.0: PCI INT A disabled
> > > [    1.372084] ath5k: probe of 0000:02:00.0 failed with error -2
> 
> Did you enable fips mode?

I don't even know what that is, so no. At least I didn't do it. if wicd did, 
then yes.

> John


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
