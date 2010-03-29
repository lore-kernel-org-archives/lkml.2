Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab0C2S0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:26:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37155 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751312Ab0C2S0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:26:36 -0400
Date: Mon, 29 Mar 2010 14:26:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Aristeu Sergio Rozanski Filho <aris@ruivo.org>
Cc: mingo@elte.hu, peterz@infradead.org, gorcunov@gmail.com, aris@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [watchdog] combine nmi_watchdog and softlockup
Message-ID: <20100329182617.GI15159@redhat.com>
References: <20100323213338.GA29170@redhat.com>
 <20100328024650.GA26522@jake.ruivo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100328024650.GA26522@jake.ruivo.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 10:46:50PM -0400, Aristeu Sergio Rozanski Filho wrote:
> Hi Don,
> > +/* deprecated */
> > +static int __init nosoftlockup_setup(char *str)
> > +{
> > +	no_watchdog = 1;
> > +	return 1;
> > +}
> > +__setup("nosoftlockup", nosoftlockup_setup);
> > +static int __init nonmi_watchdog_setup(char *str)
> > +{
> > +	no_watchdog = 1;
> > +	return 1;
> > +}
> > +__setup("nonmi_watchdog", nonmi_watchdog_setup);
> didn't you just add nonmi_watchdog parameter? I don't think there's a reason
> to keep compatibility here.

Hmm, I think you are right.  I thought I added that because it existed in
the old nmi_watchdog setup but I can't find it.  So yeah, I can drop that.

Thanks,
Don
