Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752499Ab2AOKiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 05:38:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55273 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab2AOKiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 05:38:07 -0500
Date: Sun, 15 Jan 2012 11:38:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [GIT] Security subsystem updates for 3.3
Message-ID: <20120115103804.GB6698@atrey.karlin.mff.cuni.cz>
References: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org>
 <CA+55aFwD2-bhd32L1SsjPQrpwOBhBdxTUaOj=oXN24vPwc+Wsg@mail.gmail.com>
 <alpine.LRH.2.00.1201111834570.2966@tundra.namei.org>
 <CA+55aFxecGt54RG3EX+LTQQx6ZXzYLOMRdgRmXTRDaD54JAVGg@mail.gmail.com>
 <CALLzPKaSmpKot=bgm7qQ8a7J4-sxXLsMPrHz6Pe0SyzWpZp-yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALLzPKaSmpKot=bgm7qQ8a7J4-sxXLsMPrHz6Pe0SyzWpZp-yQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Jan 11, 2012 at 4:51 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > On Tue, Jan 10, 2012 at 11:35 PM, James Morris <jmorris@namei.org> wrote:
> >>> And "DIGSIG" is really a horrible config name. Did somebody run out of
> >>> letters suddenly? Is there some global letter shortage that I haven't
> >>> been told of and that we should do something about?
> >>
> >> Any objections to DIGITAL_SIGNATURE_API ?
> >
> > Sounds much better. Slightly more typing, but CONFIG_DIGSIG really
> > didn't tell me anything and sounded like some odd new device to me.
> >
> >                          Linus
> 
> Would just DIGITAL_SIGNATURE be enough?

Actually, "CONFIG_SIGNATURE" should be enough.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
