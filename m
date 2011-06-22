Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab1FVKox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 06:44:53 -0400
Received: from trinity.fluff.org ([89.16.178.74]:60757 "EHLO trinity.fluff.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756287Ab1FVKow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 06:44:52 -0400
Date: Wed, 22 Jun 2011 11:44:42 +0100
From: Ben Dooks <ben-i2c@fluff.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Olof Johansson <olof@lixom.net>, John Bonesio <bones@secretlab.ca>,
        kradtke@nvidia.com, swarren@nvidia.com, lucas.demarchi@profusion.mobi,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        riyer@nvidia.com, linux-i2c@vger.kernel.org, ben-linux@fluff.org,
        khali@linux-fr.org, Olof Johansson <olofj@google.com>
Subject: Re: [PATCH] ARM: Tegra: i2c driver
Message-ID: <20110622104442.GK15795@trinity.fluff.org>
References: <20110621002318.8086.48367.stgit@riker> <BANLkTi=aaSnT-incv3FhOZ0Yp8CtYf31mA@mail.gmail.com> <BANLkTinJOf+L1kE9gQ99=uA_HK2_+Hts-AyAD8QuWNAa-rZ9+Q@mail.gmail.com> <BANLkTi=S8ddKE_ahHXDhW75hhPohqS+gRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTi=S8ddKE_ahHXDhW75hhPohqS+gRQ@mail.gmail.com>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 04:34:46PM -0600, Grant Likely wrote:
> On Tue, Jun 21, 2011 at 4:11 PM, Olof Johansson <olof@lixom.net> wrote:
> > On Mon, Jun 20, 2011 at 9:59 PM, Grant Likely <grant.likely@secretlab.ca> wrote:
> >> On Mon, Jun 20, 2011 at 6:23 PM, John Bonesio <bones@secretlab.ca> wrote:
> >>> This patch modifies the tegra i2c driver so that it can be initiailized
> >>> using the device tree along with the devices connected to the i2c bus.
> >>>
> >>> Signed-off-by: John Bonesio <bones@secretlab.ca>
> >>
> >> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> >
> > Acked-by: OIof Johansson <olof@lixom.net>
> >
> >
> > (with the same suggestion to change subject as Stephen/Grant discussed
> > later in the thread).
> 
> Ben, would you like a new patch with the new subject line, or will you
> fix it up when you merge it?

Would prefer to see a new subject line.
 
-- 
Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/

Large Hadron Colada: A large Pina Colada that makes the universe disappear.

