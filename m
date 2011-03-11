Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab1CKAL3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:11:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52835 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612Ab1CKAL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:11:27 -0500
Date: Fri, 11 Mar 2011 00:10:56 +0000
From: Dr Andrew John Hughes <ahughes@redhat.com>
To: Marc Kleine-Budde <mkl@pengutronix.de>
Cc: Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, Trond.Myklebust@netapp.com,
        Greg KH <greg@kroah.com>
Subject: Re: NFS regression in 2.6.37.1 (current stable)
Message-ID: <20110311001056.GD22030@rivendell.middle-earth.co.uk>
References: <20110310185321.GA22030@rivendell.middle-earth.co.uk>
 <AANLkTikXb_NM0+3ro607k0sz1zFJFTeJwp9MmBn_ngzn@mail.gmail.com>
 <4D792A00.6090803@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D792A00.6090803@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20:44 Thu 10 Mar     , Marc Kleine-Budde wrote:
> On 03/10/2011 08:35 PM, Pekka Enberg wrote:
> [...]
> > There's some more discussion here:
> > 
> > https://bugs.gentoo.org/show_bug.cgi?id=357121
> 
> They have identified the 55ea499d60aefa3d03a77fc8590c26b5881faa92 as the
> offending commit, too. Used system is x86_64.
> 

FWIW, that 'they' is me too; I reported it there first, but decided to bring
the discussion to the kernel lists when things didn't seem to be progressing
at the distro level.

> > Greg, Trond, as this is a regression in -stable, I wonder if it's best
> > that we just revert the commit?
> 
> No - that would break arm < armv6 and IIRC parisc.
> 
> Marc
> -- 
> Pengutronix e.K.                  | Marc Kleine-Budde           |
> Industrial Linux Solutions        | Phone: +49-231-2826-924     |
> Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
> Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |
> 



-- 
Andrew :)

Free Java Software Engineer
Red Hat, Inc. (http://www.redhat.com)

