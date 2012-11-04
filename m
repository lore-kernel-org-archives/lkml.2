Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754499Ab2KDNxK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 08:53:10 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:39240 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754293Ab2KDNxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 08:53:05 -0500
Date: Sun, 4 Nov 2012 13:52:51 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121104135251.GA17894@srcf.ucam.org>
References: <20121102175416.GA11816@srcf.ucam.org>
 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
 <20121102180458.GA12052@srcf.ucam.org>
 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
 <20121103002244.GC18691@srcf.ucam.org>
 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
 <20121103134630.GA28166@srcf.ucam.org>
 <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
 <20121104042802.GA11295@srcf.ucam.org>
 <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 04, 2012 at 09:14:47AM +0000, James Bottomley wrote:

> I've actually had more than enough experience with automated installs
> over my career: they're either done by paying someone or using a
> provisioning system.  In either case, they provision a static image and
> boot environment description, including EFI boot services variables, so
> you can provision a default MOK database if you want the ignition image
> not to pause on firstboot.

And now you've moved the attack vector to a copy of your provisioning 
system instead.

> There is obviously the question of making the provisioning systems
> secure, but it's a separate one from making boot secure.

You don't get to punt on making the kernel secure by simply asserting 
that some other system can be secure instead. The chain of trust needs 
to go all the way back - if your security model is based on all installs 
needing a physically present end user, all installs need a physically 
present end user. That's not acceptable, so we need a different security 
model.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
