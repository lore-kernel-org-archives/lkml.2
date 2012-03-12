Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2CLTfA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 15:35:00 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60840 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755851Ab2CLTe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 15:34:59 -0400
Date: Mon, 12 Mar 2012 19:34:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: Arnd Bergmann <arnd@arndb.de>, Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <20120312193455.GZ12704@decadent.org.uk>
References: <20120312002046.041448832@1wt.eu>
 <201203121702.06598.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201203121702.06598.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 02/12] Remove COMPAT_IA32 support
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 05:02:06PM +0000, Arnd Bergmann wrote:
> On Monday 12 March 2012, Willy Tarreau wrote:
> > 
> > 2.6.32-longterm review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Ben Hutchings <ben@decadent.org.uk>
> > 
> > commit 32974ad4907cdde6c9de612cd1b2ee0568fb9409 upstream
> > 
> > This just changes Kconfig rather than touching all the other files the
> > original commit did.
> > 
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> 
> I think it would be useful to copy the entire description of the
> original patch here, which makes it clear why it's a good idea
> to apply this patch to 2.6.32-longterm.
 
Agreed.  Willy, will you do this or should I send a new patch?

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
