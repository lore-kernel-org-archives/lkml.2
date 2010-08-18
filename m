Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab0HRLyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 07:54:35 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:48423 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577Ab0HRLye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 07:54:34 -0400
Date: Wed, 18 Aug 2010 13:54:21 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Input: fix faulty XXinput_* calls
Message-ID: <20100818115421.GJ17833@buzzloop.caiaq.de>
References: <20100812162218.GA21286@core.coreip.homeip.net>
 <AANLkTikj2kqifwYo1c47+9knVejny1bR=Oe5yOkAchCk@mail.gmail.com>
 <20100817143851.GW10432@buzzloop.caiaq.de>
 <20100817162625.GA13896@core.coreip.homeip.net>
 <20100818051435.GA1583@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818051435.GA1583@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:14:38PM -0700, Dmitry Torokhov wrote:
> On Tue, Aug 17, 2010 at 09:26:25AM -0700, Dmitry Torokhov wrote:
> > I think there still a couple of spots need to be adjusted. How about
> > this one? (Sorry for the silence, I'm in the middle of a vacation).
> 
> And still there were more issues (missing semicolons, I think they were
> there for a long time as TABLET_AUTOADJUST is not normally defined). I
> have a fix that makes hil_kbd.c compile in my tree and I will post a
> pull request in a day or so.

Ok, thanks a lot!

Daniel
