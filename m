Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757439Ab0GDLI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 07:08:29 -0400
Received: from DMZ-MAILSEC-SCANNER-8.MIT.EDU ([18.7.68.37]:61305 "EHLO
	dmz-mailsec-scanner-8.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757172Ab0GDLI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 07:08:27 -0400
X-Greylist: delayed 300 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jul 2010 07:08:27 EDT
X-AuditID: 12074425-b7b12ae0000009fd-f7-4c306a7e9107
Subject: Re: Closed source userspace graphics drivers with an open source  kernel component
Mime-Version: 1.0 (Apple Message framework v1081)
Content-Type: text/plain; charset=us-ascii
From: Theodore Tso <tytso@MIT.EDU>
In-Reply-To: <AANLkTim9Y7m3gU-w6kHvQeXT92h11kIpM8dAVaDO12uZ@mail.gmail.com>
Date: Sun, 4 Jul 2010 07:03:22 -0400
Cc: Magnus Wendt <magnus.wendt@gmail.com>, Luc Verhaegen <libv@skynet.be>,
       LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Transfer-Encoding: 7bit
Message-Id: <131ED6E6-9BAB-4BAC-A795-889C765C35F6@mit.edu>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com> <20100702095815.GA6802@skynet.be> <AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com> <20100702111029.GB6802@skynet.be> <AANLkTikomWNbwHT-kQOm8UsUS1xkMW69cZ-mC6d8Dj56@mail.gmail.com> <AANLkTinZXHi_mbmsX1HTzbMNjQx7j0rbEfTKSoz-02CF@mail.gmail.com> <AANLkTim9Y7m3gU-w6kHvQeXT92h11kIpM8dAVaDO12uZ@mail.gmail.com>
To: Dave Airlie <airlied@gmail.com>
X-Mailer: Apple Mail (2.1081)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jul 4, 2010, at 3:27 AM, Dave Airlie wrote:

> So its as crap as the others since the kernel space is uninteresting
> and doesn't give you any idea how to actually use the GPU, its just a
> slightly intelligent shim which transfers command streams and
> interrupt to/from gpu/userspace.
> 
> Its like having an ELF loader but no source to the compiler or linker,
> and saying the CPU is open.

We have sources to our web browsers but not to the a number of the
various web services that the browsers talk to (GMail, AIM, Gmane, 
Yahoo Finance, Google Search, etc.).    

And we have the sources to the Intel wireless drivers, but not to the
firmware, and that's not necessarily considered a horrendous thing.  

And we generally consider our laptops to be open even though
we don't have access to the BIOS or the SMBIOS, which can
interrupt the OS at any time, potentially for milliseconds at a time.

So the world isn't quite as black  and white as you would make things
out to be...

-- Ted

