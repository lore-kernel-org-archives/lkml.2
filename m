Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2KPUgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:36:17 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:54377 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751682Ab2KPUgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:36:16 -0500
Message-ID: <1353098204.9490.21.camel@jlt4.sipsolutions.net>
Subject: Re: removal of sysfs wext extension broke on F16
From: Johannes Berg <johannes@sipsolutions.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, John Linville <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bill Nottingham <notting@redhat.com>, linux-wireless@vger.kernel.org
Date: Fri, 16 Nov 2012 21:36:44 +0100
In-Reply-To: <1353098137.9490.20.camel@jlt4.sipsolutions.net> (sfid-20121116_213518_404111_CB0441EC)
References: <CAPM=9twSHBet=vDY9q4BXKv7ZUPR-eme75tOzxrWf6Bsp4MMkw@mail.gmail.com>
	 <1352795227.9466.8.camel@jlt4.sipsolutions.net>
	 <CA+55aFw8Rx6TScXV_nsh4EFeCDTxsjn9mJPqo8VzPhbG9jC5Fw@mail.gmail.com>
	 (sfid-20121116_192027_176167_6DFB40B3) <1353098137.9490.20.camel@jlt4.sipsolutions.net>
	 (sfid-20121116_213518_404111_CB0441EC)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.1-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-11-16 at 21:35 +0100, Johannes Berg wrote:
> On Fri, 2012-11-16 at 10:20 -0800, Linus Torvalds wrote:
> > On Tue, Nov 13, 2012 at 12:27 AM, Johannes Berg
> > <johannes@sipsolutions.net> wrote:
> > >
> > > Should I revert it and send it in my next pull request?
> > 
> > Please do. Or perhaps we could just add the directory back, without
> > the actual entries, if that is sufficient..
> 
> Yeah, that does seem to be sufficient, I'll queue up the patch below.

Err, no, wishful thinking. I need a *little* bit more for sysfs to work.

johannes

