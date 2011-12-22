Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1LVPWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 10:22:36 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55062 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab1LVPWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 10:22:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Ohad Ben-Cohen" <ohad@wizery.com>
Subject: Re: Adding remoteproc/rpmsg to linux-next
Date: Thu, 22 Dec 2011 15:22:20 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm" <linux-arm-kernel@lists.infradead.org>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-next@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Brian Swetland <swetland@google.com>, akpm@linux-foundation.org,
        Greg KH <greg@kroah.com>, Stephen Boyd <sboyd@codeaurora.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Saravana Kannan <skannan@codeaurora.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Walleij <linus.walleij@linaro.org>
References: <CAK=WgbaU6vpiBGSgogYPjQNmrF-U0wk1rSXMX83DdgQa9hw5Mw@mail.gmail.com> <20111212103301.5ff6a582dca82394ace40e8d@canb.auug.org.au> <CAK=WgbZm9txdvZ1VW-iUn5306yMz1Y=DT_Uygwi6zPZNyWx7gA@mail.gmail.com>
In-Reply-To: <CAK=WgbZm9txdvZ1VW-iUn5306yMz1Y=DT_Uygwi6zPZNyWx7gA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112221522.21146.arnd@arndb.de>
X-Provags-ID: V02:K0:hBVOvB278dLgsdTRxcGzVAv3RKGYAhiObPebX0Cx2e+
 x/ilo+PMxjg3c5VhSqeTritjOuqjt87Ec19nxtcJDq8MzQ8qtf
 kSgXuWIoojiL6/perjq0Xl4pzEbLlJtyRX6PCd6/kplVPd2MVr
 MLRZpIkdLoMEqqIvS+LFj5QWQmP5+WqL7Ol8zdUK3Vq12Xjn1p
 RyDhfYa+Q9E5gFfLerO5LKOV/nLzkYOIKmK/97iwDUFf7lGL4M
 hM1A81lKcglsQlJuvsvRWakNTK5BDKkbHvcsaXLAlh9qUMJM60
 uAGhnC8VOpEgp7msdcQetJnXMvudzxJVsACS6UPxo7wEvjCfYZ
 rAMIZ0ulC1vagNHSmBqA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 December 2011, Ohad Ben-Cohen wrote:
> Hi Arnd,
> 
> On Mon, Dec 12, 2011 at 1:33 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > On Fri, 9 Dec 2011 16:55:27 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:
> >>
> >> Can you please add the following remoteproc tree to linux-next ?
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/ohad/remoteproc.git for-next
> >
> > I have added that from today.
> 
> Would you like rpmsg/remoteproc to go through arm-soc or do you prefer
> me to send a pull request directly to Linus ?
> 
> If you prefer the former (IIRC you told me you might consider it in a
> random ELCE hallway conversation :) then I'll send you a pull request.
> 
> I'm happy either way.

Either way works for me, too. Right now, I would tend to let you send it
to Linus directly because I haven't looked at the latest versions of the
code for some time. While I generally trust you to do the right thing
there, I'm not 100% comfortable to vouch for it in the way that an Ack
or pull would imply without doing a more detailed review of the latest
code.

I know that I promised you that review, but haven't gotten to it, sorry.
I've done a 5 minute review now and it absolutely looks good to go in
as far as I can tell, so I certainly don't object to you sending it
to Linus for 3.3. If you think you need more Acks or if there are other
reasons to have it go through arm-soc, please tell me and I'll try harder
to find the time for a proper review.

	Arnd
