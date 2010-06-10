Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759902Ab0FJWex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 18:34:53 -0400
Received: from s12.ALPHA-c2.vectant.ne.jp ([222.230.51.12]:44546 "EHLO
	s12.ALPHA-c2.vectant.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759875Ab0FJWer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 18:34:47 -0400
Message-Id: <201006102231.AA00429@tamuki.linet.gr.jp>
From: TAMUKI Shoichi <tamuki@linet.gr.jp>
Date: Fri, 11 Jun 2010 07:31:13 +0900
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Anton Blanchard <anton@samba.org>,
       Andi Kleen <andi@firstfloor.org>, Andy Green <andy@warmcat.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       TAMUKI Shoichi <tamuki@linet.gr.jp>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] panic: keep blinking in spite of long spin timer mode
In-Reply-To: <20100609151552.d1a8ca8d.akpm@linux-foundation.org>
References: <20100609151552.d1a8ca8d.akpm@linux-foundation.org>
MIME-Version: 1.0
X-Mailer: AL-Mail32 Version 1.13
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, 9 Jun 2010 15:15:52 -0700 Andrew Morton wrote:

> Morse code?  Kidding?

I'm sorry, I'm confusing you.

> Sorry, no.  Nobody who uses this feature will know what what
> "words per minute" means.  It's nutty!

That is just a strained interpretation where the measure of the
blinking speed comes from.  The description of "words per minute"
has already disappeared in the latest patch.

> Please remind me why we're making this configurable at all.  Can't we
> just hardwire the thing to 1Hz or something?  Add an
> im_using_a_hypervisor boot option or something, if necessary?

For now, gta02_panic_blink(), one of panic_blink() users, expects a
10Hz call rate.  IOW, it blinks at 5Hz (i.e. panicblink=36).  I think
that the desirable blinking speed is different according to devices.

Regards,
TAMUKI Shoichi
