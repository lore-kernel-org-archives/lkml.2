Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757808Ab0GDPhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 11:37:23 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:42143 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757602Ab0GDPhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 11:37:22 -0400
Date: Sun, 4 Jul 2010 16:37:08 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Theodore Tso <tytso@MIT.EDU>
Cc: Dave Airlie <airlied@gmail.com>, Magnus Wendt <magnus.wendt@gmail.com>,
       Luc Verhaegen <libv@skynet.be>, LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Subject: Re: Closed source userspace graphics drivers with an open source
	kernel component
Message-ID: <20100704153708.GA21516@srcf.ucam.org>
References: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com> <20100702095815.GA6802@skynet.be> <AANLkTimNgjtvDYY42dm-6akRjQfkHayagQWwHSS3AQs7@mail.gmail.com> <20100702111029.GB6802@skynet.be> <AANLkTikomWNbwHT-kQOm8UsUS1xkMW69cZ-mC6d8Dj56@mail.gmail.com> <AANLkTinZXHi_mbmsX1HTzbMNjQx7j0rbEfTKSoz-02CF@mail.gmail.com> <AANLkTim9Y7m3gU-w6kHvQeXT92h11kIpM8dAVaDO12uZ@mail.gmail.com> <131ED6E6-9BAB-4BAC-A795-889C765C35F6@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <131ED6E6-9BAB-4BAC-A795-889C765C35F6@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 04, 2010 at 07:03:22AM -0400, Theodore Tso wrote:

> We have sources to our web browsers but not to the a number of the
> various web services that the browsers talk to (GMail, AIM, Gmane, 
> Yahoo Finance, Google Search, etc.).    
> 
> And we have the sources to the Intel wireless drivers, but not to the
> firmware, and that's not necessarily considered a horrendous thing.  

But we did consider it a horrendous thing when we had the source to a 
Intel wireless driver but not the source to the usercode regulatory 
daemon it required. Sufficiently horrendous not to merge the driver.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
