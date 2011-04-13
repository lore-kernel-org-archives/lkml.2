Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235Ab1DMIM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 04:12:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:59625 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756080Ab1DMIMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 04:12:55 -0400
Date: Wed, 13 Apr 2011 10:12:46 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Gabriel Paubert <paubert@iram.es>
Cc: Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>,
        Greg KH <greg@kroah.com>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: small git lesson [Was: Re: Revert
 737a3bb9416ce2a7c7a4170852473a4fcc9c67e8 ?]
Message-ID: <20110413081246.GK18850@pengutronix.de>
References: <20110404235259.GA30132@iram.es>
 <20110406084101.GB13963@pengutronix.de>
 <BANLkTimAJ-s_3A3L1YGfoFLmd4bpu2jWVA@mail.gmail.com>
 <20110406204327.GA11148@iram.es>
 <1302185075.24704.143.camel@thor.local>
 <20110411133128.GA24344@iram.es>
 <1302535963.24704.268.camel@thor.local>
 <20110412113033.GA16649@iram.es>
 <1302608770.27054.36.camel@thor.local>
 <20110413080204.GA3871@iram.es>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110413080204.GA3871@iram.es>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 10:02:04AM +0200, Gabriel Paubert wrote:
> On Tue, Apr 12, 2011 at 01:46:10PM +0200, Michel Dänzer wrote:
> > BTW, if your kernel contains commit
> > 69a07f0b117a40fcc1a479358d8e1f41793617f2, can you try if reverting that
> > helps?
> 
> My kernel is pristine 2.6.38 and does not include this commit
> (was introduced before 2.6.39-rc1 according to gitk).
gitk is not the best tool to find this out.

$ git name-rev --refs=refs/tags/v2.6\* 69a07f0b117a40fcc1a479358d8e1f41793617f2
69a07f0b117a40fcc1a479358d8e1f41793617f2 tags/v2.6.39-rc2~3^2~43^2~4

so it was introduced just before -rc2.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
