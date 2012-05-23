Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab2EWKNc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:13:32 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:60028 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751409Ab2EWKNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:13:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AoUJAJm3vE9bdWOb/2dsb2JhbABDhS+mVCKICIEHghYBBSMEUhALGgImAgJXBoglqAKSdIEmjhWBFAOeOoZSgmw
X-IronPort-AV: E=Sophos;i="4.75,644,1330902000"; 
   d="scan'208";a="518530307"
Message-ID: <1337768001.3666.6.camel@fourier.local.igalia.com>
Subject: Re: [PATCH 3/4] Staging: ipack/bridges/tpci200: remove
 TPCI200_SHORTNAME constant
From: Samuel Iglesias =?ISO-8859-1?Q?Gons=E1lvez?= 
	<siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Date: Wed, 23 May 2012 12:13:21 +0200
In-Reply-To: <20120519003724.GA10111@kroah.com>
References: <1337332208-26057-1-git-send-email-siglesias@igalia.com>
	 <1337332208-26057-3-git-send-email-siglesias@igalia.com>
	 <20120519003724.GA10111@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-18 at 17:37 -0700, Greg Kroah-Hartman wrote:
[...]
> >  	if (dev->slot >= TPCI200_NB_SLOT) {
> > -		pr_info("Slot [%s %d:%d] doesn't exist! Last tpci200 slot is %d.\n",
> > -			TPCI200_SHORTNAME, dev->bus_nr, dev->slot,
> > -			TPCI200_NB_SLOT-1);
> > +		pr_info("Slot [%d:%d] doesn't exist! Last tpci200 slot is %d.\n",
> > +			dev->bus_nr, dev->slot, TPCI200_NB_SLOT-1);
> 
> All of these should really be dev_err() calls, right?
> 
> You should have no pr_* calls at all in any driver, and probably none in
> the ipack core as well, care to fix them all up?

Yes, I will fix it in the next bunch of patches. I don't forget it.

By the way, sometime ago, you suggested me to use the ics interface for
giving the bus number if there is no HW boundary of the number of them.
However, I searched the source code and I didn't find any reference to
the ics interface. Can you tell me where is it declared?

Thanks,

Sam 

