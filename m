Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301Ab2KEIU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:20:28 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:52131 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751979Ab2KEIUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:20:24 -0500
Message-ID: <1352103617.2456.3.camel@dabdike>
Subject: Re: [RFC] Second attempt at kernel secure boot support
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Date: Mon, 05 Nov 2012 09:20:17 +0100
In-Reply-To: <20121104135251.GA17894@srcf.ucam.org>
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
	 <20121104135251.GA17894@srcf.ucam.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-11-04 at 13:52 +0000, Matthew Garrett wrote:
> On Sun, Nov 04, 2012 at 09:14:47AM +0000, James Bottomley wrote:
> 
> > I've actually had more than enough experience with automated installs
> > over my career: they're either done by paying someone or using a
> > provisioning system.  In either case, they provision a static image and
> > boot environment description, including EFI boot services variables, so
> > you can provision a default MOK database if you want the ignition image
> > not to pause on firstboot.
> 
> And now you've moved the attack vector to a copy of your provisioning 
> system instead.

Well, no, it always exists: a lot of provisioning systems install efi
(or previously dos) based agents not linux kernels.  However it's a
different vector since the efi agents tend to want to PXE boot and
contact the image server.

> > There is obviously the question of making the provisioning systems
> > secure, but it's a separate one from making boot secure.
> 
> You don't get to punt on making the kernel secure by simply asserting 
> that some other system can be secure instead. The chain of trust needs 
> to go all the way back - if your security model is based on all installs 
> needing a physically present end user, all installs need a physically 
> present end user. That's not acceptable, so we need a different security 
> model.

I didn't.  I advocated a simple security model which you asserted
wouldn't allow unattended installs, so I explained how they could be
done.  

James


