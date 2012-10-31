Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760885Ab2JaWTe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 18:19:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755502Ab2JaWTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 18:19:32 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Chris Friesen <chris.friesen@genband.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>,
        Jiri Kosina <jkosina@suse.cz>, Josh Boyer <jwboyer@gmail.com>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 23:19:31 +0100
Message-ID: <36538307.gzWq1oO7Kg@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.7.0-rc3-12-desktop+; KDE/4.9.1; x86_64; ; )
In-Reply-To: <50919EED.3020601@genband.com>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <2548314.3caaFsMVg6@linux-lqwf.site> <50919EED.3020601@genband.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 31 October 2012 15:58:05 Chris Friesen wrote:
> On 10/31/2012 02:14 PM, Oliver Neukum wrote:

> > That would do it on my system.
> > Maybe in theory you could solve this by the kernel invalidating images
> > it hasn't written itself and forbidding to change the resume partition from the
> > kernel command line, but that would break user space hibernation.
> 
> If the resuming kernel refuses to resume from images it didn't create 
> itself, why do you need to forbid changing the resume partition from the 
> kernel command line?

You don't. Signed images solve the problem.

I was responding to Alan's assertation that the problem could be solved
without signing the images. It turns out tht any such scheme would have
unacceptable limitations.

The key problem is actually safely storing the public key needed to verify
the signature. This problem is also solvable. It just needs help from the
UEFI infrastructure.

	Regards
		Oliver

