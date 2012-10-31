Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab2JaWAs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:00:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43162 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738Ab2JaWAq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:00:46 -0400
Date: Wed, 31 Oct 2012 23:00:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
In-Reply-To: <50919EED.3020601@genband.com>
Message-ID: <alpine.LNX.2.00.1210312259300.22374@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <20121031171743.GA17652@srcf.ucam.org> <20121031173919.4fc63ddd@pyramind.ukuu.org.uk> <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Oct 2012, Chris Friesen wrote:

> > That would do it on my system.
> > Maybe in theory you could solve this by the kernel invalidating images
> > it hasn't written itself and forbidding to change the resume partition from
> > the
> > kernel command line, but that would break user space hibernation.
> 
> If the resuming kernel refuses to resume from images it didn't create itself,
> why do you need to forbid changing the resume partition from the kernel
> command line?

Yeah, it can definitely be solved by pushing keys around from shim to 
kernel (and kernel discarding the private keys at right moments). It just 
needs to be implemented.

-- 
Jiri Kosina
SUSE Labs
