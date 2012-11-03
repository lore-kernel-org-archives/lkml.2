Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab2KCNqn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 09:46:43 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:34075 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754504Ab2KCNql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 09:46:41 -0400
Date: Sat, 3 Nov 2012 13:46:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Message-ID: <20121103134630.GA28166@srcf.ucam.org>
References: <20121102163302.GA6080@elf.ucw.cz>
 <1351875164.2439.42.camel@dabdike.int.hansenpartnership.com>
 <20121102165456.GB9997@srcf.ucam.org>
 <1351878511.2439.44.camel@dabdike.int.hansenpartnership.com>
 <20121102175416.GA11816@srcf.ucam.org>
 <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
 <20121102180458.GA12052@srcf.ucam.org>
 <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
 <20121103002244.GC18691@srcf.ucam.org>
 <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 03, 2012 at 12:03:56PM +0000, James Bottomley wrote:
> On Sat, 2012-11-03 at 00:22 +0000, Matthew Garrett wrote:
> > Why would an attacker use one of those Linux systems? There's going to 
> > be plenty available that don't have that restriction.
> 
> It's called best practices.  If someone else releases something that
> doesn't conform to them, then it's their signing key in jeopardy, not
> yours.  You surely must see that the goal of securing "everything"
> against "anything" isn't achievable because if someone releases a
> bootloader not conforming to the best practices, why would they have
> bothered to include your secure boot lockdowns in their kernel.  In
> other words, you lost ab initio, so it's pointless to cite this type of
> thing as a rationale for a kernel lockdown patch.

I... what? Our signed bootloader will boot our signed kernel without any 
physically present end-user involvement. We therefore need to make it 
as difficult as practically possible for an attacker to use our signed 
bootloader and our signed kernel as an attack vector against other 
operating systems, which includes worrying about hibernate and kexec. If 
people want to support this use case then patches to deal with that need 
to be present in the upstream kernel.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
