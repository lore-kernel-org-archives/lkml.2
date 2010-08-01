Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab0HAPFP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 11:05:15 -0400
Received: from mx.treblig.org ([80.68.94.177]:33414 "EHLO mx.treblig.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421Ab0HAPFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 11:05:13 -0400
X-Greylist: delayed 2013 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Aug 2010 11:05:13 EDT
Date: Sun, 1 Aug 2010 15:17:21 +0100
From: "Dr. David Alan Gilbert" <linux@treblig.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        ksummit-2010-discuss@lists.linux-foundation.org
Subject: Re: PSA: Please update your flash plugin!
Message-ID: <20100801141721.GA11854@gallifrey>
References: <E1OefgE-0005vu-JN@tytso-glaptop> <4C524F7A.20505@gmail.com> <4C558237.1040705@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C558237.1040705@panasas.com>
X-Chocolate: 70 percent or better cocoa solids preferably
X-Operating-System: Linux/2.6.31.5-kvm-i386-2009-10-30 (i686)
X-Uptime: 15:11:27 up 258 days, 20:46,  1 user,  load average: 0.00, 0.00,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Boaz Harrosh (bharrosh@panasas.com) wrote:
> On 07/30/2010 07:05 AM, Justin P. Mattock wrote:
> > On 07/29/2010 07:50 PM, Theodore Ts'o wrote:

<snip - warning>

> > biggest problem here is they havn't updated their x86_64(pure64) version 
> > yet. hopefully hey release an update soon.
> > 
> > Justin P. Mattock
> > --
> 
> Here too. How do I run (any) Flash-10.1 on a 64bit system (say FC12) without
> actually reverting to a 32bit browser? Do I still get to install half of my
> system as 32bit duplicates?

nspluginwrapper works well enough for me on Ubuntu, but this
isn't a kernel problem. (It seems to work better for me in Chrome
than ff but hey that's another problem again).

Since there isn't an announced date for if a 64bit version is going
to be available (only a fluffy statement that they intend to do one)
it's a case of having to move back to 32.

See: http://www.theregister.co.uk/2010/06/11/64_bit_flash_for_linux_dead/

Dave
-- 
 -----Open up your eyes, open up your mind, open up your code -------   
/ Dr. David Alan Gilbert    |       Running GNU/Linux       | Happy  \ 
\ gro.gilbert @ treblig.org |                               | In Hex /
 \ _________________________|_____ http://www.treblig.org   |_______/
