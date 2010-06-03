Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0FCPBd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:01:33 -0400
Received: from cantor.suse.de ([195.135.220.2]:47113 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756044Ab0FCPBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:01:31 -0400
Date: Thu, 3 Jun 2010 07:45:04 -0700
From: Greg KH <gregkh@suse.de>
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: b.a.t.m.a.n@lists.open-mesh.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, Sven Eckelmann <sven.eckelmann@gmx.de>,
       devel <devel@driverdev.osuosl.org>,
       Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Subject: Re: [B.A.T.M.A.N.] [PATCH] drivers/staging/batman-adv: Convert
 MAC_FMT to %pM
Message-ID: <20100603144504.GC17831@suse.de>
References: <1275509418.23599.42.camel@Joe-Laptop.home>
 <201006030156.42370.sven.eckelmann@gmx.de>
 <1275524401.23599.116.camel@Joe-Laptop.home>
 <201006031715.54584.lindner_marek@yahoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006031715.54584.lindner_marek@yahoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:15:53PM +0800, Marek Lindner wrote:
> On Thursday 03 June 2010 08:20:01 Joe Perches wrote:
> > The patch changes the prefix from "batman-adv:" to "batman_adv: "
> > so yes, it would break as-is.
> > 
> > I think the concept is broken though, I believe dmesg output
> > specifically is not guaranteed to remain stable, and batman should
> > use some other, perhaps private, logger based on ethtool events.
> 
> I think changing a dash to an underscore is not such a big deal (I did not 
> check the rest of the patch yet). But I'm interested to hear more about your 
> "private logger" idea because the current solution is far from being perfect. 
> As we have to debug the routing protocol every now and then it would be very 
> helpful to get direct access to some internal logging facility. In fact, that 
> existed before (inside of /proc) but was removed to be more compliant with the 
> linux kernel and the existing log facilities.

You can always use debugfs if you like for something like this.

Or tie into the profile/perf subsystem, that might be even easier.

thanks,

greg k-h
