Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754974Ab0I3Ho2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 03:44:28 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56769 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754483Ab0I3Ho1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 03:44:27 -0400
Date: Thu, 30 Sep 2010 09:44:23 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the i.MX
	tree
Message-ID: <20100930074423.GL29811@pengutronix.de>
References: <20100930112302.e554d367.sfr@canb.auug.org.au> <20100930033110.GA5762@opensource.wolfsonmicro.com> <20100930064533.GJ29811@pengutronix.de> <20100930065813.GA1744@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100930065813.GA1744@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 11:58:13PM -0700, Mark Brown wrote:
> On Thu, Sep 30, 2010 at 08:45:33AM +0200, Uwe Kleine-König wrote:
> 
> > I might be wrong, but I think there are no non-audio users of the ssi
> > device?
> 
> That's kind of the point; while this is a generic serial port I've never
> seen it used for anything except audio.
> 
> > I think the correct fix is to squash the patch I just sent into the
> > commit merging the two.
> 
> If there's no non-audio users there's no need to do the rename - the
> renames are to avoid having the ASoC DAI drivers suddenly start binding
> with other drivers so we could just revert the rename in ASoC which
> would remove the merge issue.
Ah, now I got your point.  Your suggestion to keep the name for now
(until maybe in the future we get other users) sounds sensible.

Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
