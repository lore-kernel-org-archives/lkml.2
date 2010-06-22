Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab0FVXYM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:24:12 -0400
Received: from ozlabs.org ([203.10.76.45]:52770 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315Ab0FVXYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:24:10 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PULL] param sysfs oops (simple, leaky) fix, bool arrays fix
Date: Wed, 23 Jun 2010 08:53:58 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: "dedekind1@gmail.com" <dedekind1@gmail.com>, Takashi Iwai <tiwai@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Sitsofe Wheeler <sitsofe@yahoo.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Christof Schmitt <christof.schmitt@de.ibm.com>
References: <200910290902.13724.rusty@rustcorp.com.au> <201005061158.13098.rusty@rustcorp.com.au> <20100622165011.GZ17639@pcarmody-desktop>
In-Reply-To: <20100622165011.GZ17639@pcarmody-desktop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006230854.00441.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jun 2010 02:20:11 am Phil Carmody wrote:
> Artem's passed the baton over to me to investigate, so I've reviewed
> and back-ported the last known version of your patchset. I'm happy to 
> report that the 100% reproducable leak that we were seeing before
> cannot be reproduced. As expected, given review of the code. I have 
> not been able to test the final driver-specific patches from your 
> patchset, but up to and including
> 
> [PATCH 12/18] param: simple locking for sysfs-writable charp parameters
> 
> they can all have a:
> 
> Tested-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
> 
> I'm quite interested to see these pushed into the mainline so that I
> can cherry-pick final versions for our internal tree, do you have any 
> schedule for that?

Thanks, Phil, I've added that.  Testing is always good!

The patches are sitting in linux-next now, ready for the next merge window
(ie. 2.6.36)

Cheers,
Rusty.
