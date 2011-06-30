Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752802Ab1F3MRU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:17:20 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41702 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab1F3MRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:17:15 -0400
Date: Thu, 30 Jun 2011 14:17:10 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, git@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the security-testing tree with the
 tree
Message-ID: <20110630121710.GJ11559@pengutronix.de>
References: <20110630142910.2fea4257.sfr@canb.auug.org.au>
 <20110630072559.GA4048@pengutronix.de>
 <20110630193023.6056d48e.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110630193023.6056d48e.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 07:30:23PM +1000, Stephen Rothwell wrote:
> Hi Uwe,
> 
> On Thu, 30 Jun 2011 09:25:59 +0200 Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:
> >
> > Long history short: James probably used -s ours or similar and it's fine
> > not to merge that commit into next :-)
> 
> Ah ha!  Thanks for the explanation.  My mind was clearly not up to it
> today. :-)
The uncomfortable issue here is that 

	git show bcd05ca10420

(or gitk or gitweb or <enteryourfavoritetoolhere>) doesn't indicate that
it's "strange". The patch shown is simply empty, as it would be if the
tree matched the other parent or if it were a clean merge.

A flag would be nice that does what I did: redo the merge and compare
bcd05ca10420^{tree} with the result?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
