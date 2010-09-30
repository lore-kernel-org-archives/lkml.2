Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0I3Gph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:45:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:39125 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab0I3Gpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:45:36 -0400
Date: Thu, 30 Sep 2010 08:45:33 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: linux-next: manual merge of the sound-asoc tree with the i.MX
	tree
Message-ID: <20100930064533.GJ29811@pengutronix.de>
References: <20100930112302.e554d367.sfr@canb.auug.org.au> <20100930033110.GA5762@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100930033110.GA5762@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 08:31:11PM -0700, Mark Brown wrote:
> On Thu, Sep 30, 2010 at 11:23:02AM +1000, Stephen Rothwell wrote:
> 
> > The former removed that code that the latter changed.  I just used the
> > former.
> 
> > The latter was just changing some names, so ti may be able to be
> > integrated into the former.
> 
> Though doing that would break bisection.  The other option would be to
> revert the bit of the multi-component change that does the rename which
> I think should be safe - Sacha, Liam, does that seem sensible?  There is
> the issue with other potential non-audio users of the SSI to be
> considered.
I might be wrong, but I think there are no non-audio users of the ssi
device?

I think the correct fix is to squash the patch I just sent into the
commit merging the two.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
