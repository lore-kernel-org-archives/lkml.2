Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab2CZWVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 18:21:13 -0400
Received: from colo.foxharp.net ([166.84.7.52]:51782 "EHLO colo.foxharp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757474Ab2CZWVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 18:21:11 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Mar 2012 18:21:11 EDT
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4] x86, olpc: add debugfs interface for EC commands
From: Paul Fox <pgf@laptop.org>
cc: Daniel Drake <dsd@laptop.org>, mingo@redhat.com, tglx@linutronix.de,
        hpa@zytor.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        dilinger@queued.net
In-reply-to: <20120326142908.c5248aec.akpm@linux-foundation.org> (sfid-20120326_172921_913098_395172D1)
References: <20120326180710.8DF9C9D401E@zog.reactivated.net> <20120326142908.c5248aec.akpm@linux-foundation.org> (sfid-20120326_172921_913098_395172D1)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5752.1332800005.1@foxharp.boston.ma.us>
Date: Mon, 26 Mar 2012 18:13:25 -0400
Message-ID: <5755.1332800005@foxharp.boston.ma.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

andrew wrote:
 > On Mon, 26 Mar 2012 19:07:07 +0100 (BST)
 > Daniel Drake <dsd@laptop.org> wrote:
 > 
 > > Add a debugfs interface for sending commands to the OLPC Embedded
 > > Controller (EC) and reading the responses.  The EC provides functionality
 > > for machine identification, battery and AC control, wakeup control, etc.
 > > 
 > > Having a debugfs interface available is useful for EC development and
 > > debugging.
 > > 
 > > Based on code by Paul Fox.
 > > 
 > > Signed-off-by: Daniel Drake <dsd@laptop.org>
 > > Originally-from: Paul Fox <pgf@laptop.org>
 > > Cc: Ingo Molnar <mingo@elte.hu>
 > > Cc: Thomas Gleixner <tglx@linutronix.de>
 > > Cc: "H. Peter Anvin" <hpa@zytor.com>
 > > Cc: Andres Salomon <dilinger@queued.net>
 > > 
 > > ...
 > >
 > > v4: really fix sign-off tags
 > 
 > s/fix/break/?  "Originally-from" is not a recognised tag.  If this code
 > is based upon an earlier version from Paul then Signed-off-by: is
 > correct.
 > 
 > What's going on here?  What are you trying to communicate?


i think the way daniel had it before was likely correct.

i wrote the original code, but it looked pretty different back then. 
daniel has brought it to its current state.  i _then_ added my
Signed-off-by.

so the code is both "Based on code by Paul Fox", and my Signed-off-by
should come after daniel's (assuming chronological order).

paul
=---------------------
 paul fox, pgf@laptop.org
