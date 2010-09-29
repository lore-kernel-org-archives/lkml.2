Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756069Ab0I2NKz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:10:55 -0400
Received: from mail.solarflare.com ([216.237.3.220]:48639 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752218Ab0I2NKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:10:54 -0400
Subject: Re: [RFC] Online firmware upgrade in non-embedded systems
From: Ben Hutchings <bhutchings@solarflare.com>
To: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Cc: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        sf-linux-drivers <linux-net-drivers@solarflare.com>,
        flashrom <flashrom@flashrom.org>
In-Reply-To: <4CA334FA.2080707@gmx.net>
References: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>
	 <4CA26F35.6060408@gmx.net>
	 <1285763700.2283.6.camel@achroite.uk.solarflarecom.com>
	 <4CA334FA.2080707@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Wed, 29 Sep 2010 14:10:50 +0100
Message-ID: <1285765850.2283.15.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 13:10:54.0068 (UTC) FILETIME=[BF346340:01CB5FD7]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-17672.005
X-TM-AS-Result: No--25.854900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-09-29 at 14:45 +0200, Carl-Daniel Hailfinger wrote:
> On 29.09.2010 14:35, Ben Hutchings wrote:
> > On Wed, 2010-09-29 at 00:41 +0200, Carl-Daniel Hailfinger wrote:
> >   
> >> [adding flashrom@flashrom.org to CC, senders will be whitelisted after a
> >> short delay]
> >>
> >> On 28.09.2010 19:59, Ben Hutchings wrote:
> >>     
> >>> Network and disk controllers normally have at least some firmware in
> >>> flash to support their use as boot devices. [...]
> >>>   
> >>>       
> >> Given that the flashrom utility <http://www.flashrom.org/> (GPLv2)
> >> supports flashing many network cards, SATA/PATA controllers, graphics
> >> cards, and of course the main system firmware/BIOS/EFI, and it does that
> >> from userspace without any kernel support,
> >>     
> > [...]
> >
> > I'm looking for a clean solution, not a hack.
> >   
> 
> What would qualify as a clean solution?

One where hardware access is mediated by the kernel, and doesn't involve
unloading or potentially conflicting with the driver for that hardware.

> And is cross-platform code one of your goals?

Not at this level.  At the application level, yes, but we already have a
working application so I'm not interested in using flashrom for that.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

