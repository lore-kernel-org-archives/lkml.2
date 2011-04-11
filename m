Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab1DKTA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:00:27 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:40034 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab1DKTAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:00:25 -0400
Date: Mon, 11 Apr 2011 14:58:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@gmail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH] iwlegacy: make iwl3945 and iwl4965 select IWLWIFI_LEGACY
Message-ID: <20110411185807.GC2511@tuxdriver.com>
References: <BANLkTimoDVMcvFdoUedyfw4Thv8=DsV-5A@mail.gmail.com>
 <1302541599-15383-1-git-send-email-linville@tuxdriver.com>
 <1302547162.5663.2.camel@wwguy-ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302547162.5663.2.camel@wwguy-ubuntu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 11:39:22AM -0700, wwguy wrote:
> On Mon, 2011-04-11 at 10:06 -0700, John W. Linville wrote:
> > Otherwise, IWLWIFI_LEGACY has to be selected independently before the
> > drivers are made available.
> > 
> > Reported-by: Dave Airlie <airlied@gmail.com>
> > Signed-off-by: John W. Linville <linville@tuxdriver.com>
> > Cc: Stanislaw Gruszka <sgruszka@redhat.com>
> > Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > ---
> >  drivers/net/wireless/iwlegacy/Kconfig |    9 +++++----
> >  1 files changed, 5 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
> > index 2a45dd4..aef65cd 100644
> > --- a/drivers/net/wireless/iwlegacy/Kconfig
> > +++ b/drivers/net/wireless/iwlegacy/Kconfig
> > @@ -1,6 +1,5 @@
> >  config IWLWIFI_LEGACY
> > -	tristate "Intel Wireless Wifi legacy devices"
> > -	depends on PCI && MAC80211
> > +	tristate
> >  	select FW_LOADER
> >  	select NEW_LEDS
> >  	select LEDS_CLASS
> 
> Should we add some ---help--- here?, or not..

Why would you need it?  This is now automatically selected by the
driver -- the user doesn't see it.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
