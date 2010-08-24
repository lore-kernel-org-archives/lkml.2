Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755358Ab0HXP3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 11:29:43 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41707 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab0HXP3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 11:29:41 -0400
Date: Tue, 24 Aug 2010 11:18:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Thomas Fjellstrom <thomas@fjellstrom.ca>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ath5k problem with 2.6.35
Message-ID: <20100824151815.GE2535@tuxdriver.com>
References: <201008220005.38969.tfjellstrom@strangesoft.net>
 <201008220153.41678.thomas@fjellstrom.ca>
 <20100823182903.GE2609@tuxdriver.com>
 <201008231849.13144.thomas@fjellstrom.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201008231849.13144.thomas@fjellstrom.ca>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 06:49:12PM -0600, Thomas Fjellstrom wrote:
> On August 23, 2010, John W. Linville wrote:
> > On Sun, Aug 22, 2010 at 01:53:41AM -0600, Thomas Fjellstrom wrote:
> > > On August 22, 2010, Thomas Fjellstrom wrote:
> > > > Hi, I'm running 2.6.35, and my wireless card fails to initialize
> > > > properly
> > > 
> > > > on boot. I get the following messages in dmesg:
> > > Probably important, but I missed a couple lines:
> > > > [    0.866525] ath5k 0000:02:00.0: PCI INT A -> GSI 17 (level, low) ->
> > > > IRQ 17 [    0.866536] ath5k 0000:02:00.0: setting latency timer to 64
> > > > [    0.866571] ath5k 0000:02:00.0: registered as 'phy0'
> > > > [    1.358241] ath: EEPROM regdomain: 0x67
> > > > [    1.358242] ath: EEPROM indicates we should expect a direct regpair
> > > > map [    1.358245] ath: Country alpha2 being used: 00
> > > > [    1.358247] ath: Regpair used: 0x67
> > > > 
> > >    [    1.360589] phy0: Failed to initialize wep: -2
> > > > 
> > > > [    1.372021] ath5k phy0: can't register ieee80211 hw
> > > > [    1.372080] ath5k 0000:02:00.0: PCI INT A disabled
> > > > [    1.372084] ath5k: probe of 0000:02:00.0 failed with error -2
> > 
> > Did you enable fips mode?
> 
> I don't even know what that is, so no. At least I didn't do it. if wicd did, 
> then yes.

In any case, wep failed to init for some reason and the prevents
device registration.  You need the patch I referenced earlier.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
