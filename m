Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759458Ab2CUSJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 14:09:30 -0400
Received: from imr4.ericy.com ([198.24.6.9]:44393 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab2CUSJ3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 14:09:29 -0400
Message-ID: <1332353243.32717.207.camel@groeck-laptop>
Subject: Re: [GIT PULL] hwmon updates for 3.4
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>
Date: Wed, 21 Mar 2012 11:07:23 -0700
In-Reply-To: <CA+55aFzEQ-undQpx_Q_5+scP5EN9KxJ9m-1O-8O0h+EbZE2mMw@mail.gmail.com>
References: <20120320162358.GA5189@ericsson.com>
	 <CA+55aFzEQ-undQpx_Q_5+scP5EN9KxJ9m-1O-8O0h+EbZE2mMw@mail.gmail.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 13:40 -0400, Linus Torvalds wrote:
> On Tue, Mar 20, 2012 at 9:23 AM, Guenter Roeck
> <guenter.roeck@ericsson.com> wrote:
> >
> > Please pull hwmon updates for Linux 3.4 from tag:
> >
> >    git://git.kernel.org/pub/scm/linux/kernel/git/groeck/linux-staging.git hwmon-for-linus
> >
> > Mostly cleanup. No new drivers this time around, but support for several chips
> > added to existing drivers: TPS40400, TPS40422, MTD040, MAX34446, ZL9101M,
> > ZL9117M, and LM96080. Also added watchdog support for SCH56xx, plus additional
> > sysfs attributes for a couple of drivers.
> 
> Btw, please don't put that "git log --oneline" generated data into the
> tag - there's no real point. It doesn't add anything human-readable to
> anything, and for any automation you can get the data better directly
> from git instead.
> 
> So the tag-message shouldn't contain anything auto-generated, since
> any auto-generated data is better just generated later on the fly.
> Just do the human-readable "this is the high-level overview of that
> the pull request contains" into the tag message.
> 
>                        Linus

Ok. Sorry for the noise, and thanks for pulling the changes.

Guenter


