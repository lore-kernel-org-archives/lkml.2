Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab2KEMhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:37:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57088 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab2KEMg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:36:58 -0500
Date: Mon, 5 Nov 2012 12:36:38 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121105123638.GA4374@srcf.ucam.org>
References: <20121102180458.GA12052@srcf.ucam.org>
 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
 <20121103002244.GC18691@srcf.ucam.org>
 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
 <20121103134630.GA28166@srcf.ucam.org>
 <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
 <20121104042802.GA11295@srcf.ucam.org>
 <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
 <20121104135251.GA17894@srcf.ucam.org>
 <1352103617.2456.3.camel@dabdike>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352103617.2456.3.camel@dabdike>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2012 at 09:20:17AM +0100, James Bottomley wrote:
> On Sun, 2012-11-04 at 13:52 +0000, Matthew Garrett wrote:
> > You don't get to punt on making the kernel secure by simply asserting 
> > that some other system can be secure instead. The chain of trust needs 
> > to go all the way back - if your security model is based on all installs 
> > needing a physically present end user, all installs need a physically 
> > present end user. That's not acceptable, so we need a different security 
> > model.
> 
> I didn't.  I advocated a simple security model which you asserted
> wouldn't allow unattended installs, so I explained how they could be
> done.  

You've explained that a hypothetical piece of software could handle key 
provisioning without providing any explanation for how it would be able 
to do so in a secure manner.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
