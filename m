Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab0IMT7m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:59:42 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54104 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755260Ab0IMT7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:59:41 -0400
Date: Mon, 13 Sep 2010 15:36:47 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: David Miller <davem@davemloft.net>
Cc: tmb@mandriva.org, stable@kernel.org, gregkh@suse.de,
        Larry.Finger@lwfinger.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [33-stable regression ssb/broadcom]
Message-ID: <20100913193647.GD4052@tuxdriver.com>
References: <4C8E6192.2010003@mandriva.org>
 <20100913.122329.39186333.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913.122329.39186333.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 12:23:29PM -0700, David Miller wrote:
> From: Thomas Backlund <tmb@mandriva.org>
> Date: Mon, 13 Sep 2010 20:38:26 +0300
> 
> > In Mandriva 2010.1 we noticed that 2.6.33.7 broke ssb/Broadcom lan for
> > several users...
> > 
> > Issue is tracked at:
> > https://qa.mandriva.com/show_bug.cgi?id=60968
> > 
> > Reverting the commit restores a working lan.
> > 
> > The offending commit is:
> 
> Please always CC: netdev on networking reports, otherwise you are
> very unlikely to get any experts looking into your issue.

IIRC, there was a bad patch that got sent for the 2.6.33.y series.
I thought it had been reverted or fixed already?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
