Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab2KEVoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 16:44:13 -0500
Received: from ka.mail.enyo.de ([87.106.162.201]:58026 "EHLO ka.mail.enyo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754158Ab2KEVoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 16:44:10 -0500
X-Greylist: delayed 1105 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2012 16:44:10 EST
From: Florian Weimer <fw@deneb.enyo.de>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, Pavel Machek <pavel@ucw.cz>,
        Chris Friesen <chris.friesen@genband.com>,
        Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>,
        Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
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
	<20121103134630.GA28166@srcf.ucam.org>
	<1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
Date: Mon, 05 Nov 2012 22:25:29 +0100
In-Reply-To: <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
	(James Bottomley's message of "Sat, 03 Nov 2012 22:56:40 +0000")
Message-ID: <87sj8nzqra.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* James Bottomley:

> Right, but what I'm telling you is that by deciding to allow automatic
> first boot, you're causing the windows attack vector problem.  You could
> easily do a present user test only on first boot which would eliminate
> it.

Apparently, the warning will look like this:

  WARNING: This Binary is unsigned

  Are you sure you wish to run an unsigned binary
  in a secure environment?

  To avoid this question in future place the platform into setup mode
  See http://www.linuxfoundation.org/uefi-setup-mode
  And reboot.

I'm not convinced this will work because users will confirm their
presence to get back into the system.  We expect GNU/Linux users to do
it, why wouldn't Windows users?  (And what harm can an unsigned binary
do to a "secure environment", anyway?  If it's adversely affected, it
can't be that secure, can it?)

And what's the backup plan if users use this to boot into compromised
Windows systems?
