Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756406Ab0C3OxE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:53:04 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:44071 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0C3OxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:53:01 -0400
Date: Tue, 30 Mar 2010 10:52:38 -0400
From: Aristeu Sergio Rozanski Filho <aris@ruivo.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100330145238.GG6706@cathedrallabs.org>
References: <20100323213338.GA29170@redhat.com>
 <20100328024650.GA26522@jake.ruivo.org>
 <20100329182617.GI15159@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100329182617.GI15159@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sat, Mar 27, 2010 at 10:46:50PM -0400, Aristeu Sergio Rozanski Filho wrote:
> > Hi Don,
> > > +/* deprecated */
> > > +static int __init nosoftlockup_setup(char *str)
> > > +{
> > > +	no_watchdog = 1;
> > > +	return 1;
> > > +}
> > > +__setup("nosoftlockup", nosoftlockup_setup);
> > > +static int __init nonmi_watchdog_setup(char *str)
> > > +{
> > > +	no_watchdog = 1;
> > > +	return 1;
> > > +}
> > > +__setup("nonmi_watchdog", nonmi_watchdog_setup);
> > didn't you just add nonmi_watchdog parameter? I don't think there's a reason
> > to keep compatibility here.
> 
> Hmm, I think you are right.  I thought I added that because it existed in
> the old nmi_watchdog setup but I can't find it.  So yeah, I can drop that.
you could provide a nmi_watchdog=0 backwards compatibility and warn about
values != 0

-- 
Aristeu

