Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2EEKug (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 06:50:36 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:51146 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754595Ab2EEKue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 06:50:34 -0400
Date: Sat, 5 May 2012 03:49:10 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 0/6] twl4030: Various fixes for charing-from-USB
Message-ID: <20120505104910.GA19590@lizard>
References: <20120425072931.20124.56635.stgit@notabene.brown>
 <CANOLnOOQDxu-P=yTN6159XJANq-_FSCtZ4rBt69NSCPjLz1Rjw@mail.gmail.com>
 <20120430093002.472dfdde@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120430093002.472dfdde@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 09:30:02AM +1000, NeilBrown wrote:
> > > Following are a collection of patches that I've need using for a while
> > > to make sure the charge-from-usb on my GTA04 works.
> > > Hopefully I've included the right people in the recipient list :-)
> > 
> > You missed the power supply maintainers - ./scripts/get_maintainer.pl
> > is usually good at finding the right people, although their
> > MAINTAINERS entry could be better I guess..
> > 
> > 
> 
> I guess you mean:
> 
> POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
> M:	Anton Vorontsov <cbou@mail.ru>
> M:	David Woodhouse <dwmw2@infradead.org>
> T:	git git://git.infradead.org/battery-2.6.git
> S:	Maintained
> F:	include/linux/power_supply.h
> F:	drivers/power/power_supply*
> 
> 
> get_maintainer.pl didn't find them.  The F: line seems to say they aren't
> interested in individual drivers...

This is a 'bug', of course. :-) Thanks for the report.

This is what I've just applied:

- - - -
MAINTAINERS: Fix 'F' entry for the power supply class

For some reason the maintainers file only specifies power
supply core files.

We're surely interested in individual drivers as well, so fix
the entry.

Reported-by: NeilBrown <neilb@suse.de>
Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb76fc4..3766f6a 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5290,7 +5290,7 @@ M:	David Woodhouse <dwmw2@infradead.org>
 T:	git git://git.infradead.org/battery-2.6.git
 S:	Maintained
 F:	include/linux/power_supply.h
-F:	drivers/power/power_supply*
+F:	drivers/power/
 
 PNP SUPPORT
 M:	Adam Belay <abelay@mit.edu>
-- 
1.7.9.2

