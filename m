Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758165Ab1DZUst (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:48:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53909 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753389Ab1DZUss (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:48:48 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC PATCH v2 1/3] PM / Core: suspend_again callback for device PM.
Date: Tue, 26 Apr 2011 22:49:22 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, MyungJoo Ham <myungjoo.ham@samsung.com>,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        kyungmin.park@samsung.com, myungjoo.ham@gmail.com,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>
References: <1303288106-2965-1-git-send-email-myungjoo.ham@samsung.com> <20110426131737.GA13597@suse.de> <20110426203853.GC27140@elf.ucw.cz>
In-Reply-To: <20110426203853.GC27140@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104262249.22564.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 26, 2011, Pavel Machek wrote:
> Hi!
> 
> > > To conclude, I'm not sure about the approach.  In particular, I'm not sure
> > > if the benefit is worth the effort and the resulting complications (ie. the
> > > possibility of having to deal with wakeup signals not requested by user
> > > space) seem to be a bit too far reaching.
> > > 
> > > Greg, what do you think?
> > 
> > I agree with you in that I don't think that this type of feature is
> > valid at the moment.
> 
> Our current "solution" is low level suspend code on Zaurus directly
> looking at charger state and doing the "wakeup or not" decision by hand. 
> 
> > I don't understand why our current situation doesn't work, what are we
> > lacking that is needed for these systems that we have not seen
> > before?
> 
> It works, but it is ugly; and it seems samsung now needs similar
> hacks.
> 
> > What is the root problem that this is trying to solve?
> 
> It is trying to fix machines that need to run periodic kernel tasks
> even when user asked them to sleep. Zaurus needs to periodicaly wake
> up to be able to charge battery in s2ram state, for example.

Well, if you wake up periodically, it's not S2RAM any more, I'd say.

Thanks,
Rafael
