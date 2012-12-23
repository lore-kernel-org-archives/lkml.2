Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab2LWVEJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 16:04:09 -0500
Received: from 1wt.eu ([62.212.114.60]:37221 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab2LWVEH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 16:04:07 -0500
Date: Sun, 23 Dec 2012 22:03:48 +0100
From: Willy Tarreau <w@1wt.eu>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: stable@vger.kernel.org, Matthew Garrett <mjg@redhat.com>, x86@kernel.org,
        hpa@zytor.com, linux-kernel@vger.kernel.org,
        Keith Ward <keith@chaos-realm.net>,
        Ben Hutchings <ben@decadent.org.uk>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: [2.6.32.y, 2.6.34.y] Re: [PATCH] x86: Don't use the EFI reboot method by default
Message-ID: <20121223210348.GG3263@1wt.eu>
References: <1309985557-15350-1-git-send-email-mjg@redhat.com> <20121223205950.GA16511@elie.Belkin>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121223205950.GA16511@elie.Belkin>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jonathan,

[ccing Paul for 2.6.34]

On Sun, Dec 23, 2012 at 12:59:50PM -0800, Jonathan Nieder wrote:
> Hi Willy et al,
> 
> Please consider
> 
>   f70e957cda22 x86: Don't use the EFI reboot method by default,
>                2011-07-06
> 
> for application to the 2.6.32.y and 2.6.34.y trees.  The patch was
> applied upstream late in the 3.0 cycle, so newer kernels don't need
> it.
> 
> In 2011, Keith Ward wrote[1]:
> 
> > When attempting to reboot my my UEFI enabled system, the system hangs when
> > calling reboot requiring me to manually reset the system via the reset switch.
> >
> > Screenshot: http://twitgoo.com/29bq1c
> 
> Ben Hutchings writes[1]:
> 
> > Version: 3.0.0-1
> >
> > I also had this problem on my own system, but it is fixed now.
> > I bisected the fix to:
> >
> > commit f70e957cda22d309c769805cbb932407a5232219
> > Author: Matthew Garrett <mjg@redhat.com>
> > Date:   Wed Jul 6 16:52:37 2011 -0400
> >
> >     x86: Don't use the EFI reboot method by default
> >
> > which is basically equivalent to the workaround!
> >
> > I'll also apply this fix to squeeze as it's so simple.
> 
> Keith Ward also wrote[1]:
> 
> > It seems as if this has recently been reported at Ubuntu's Launchpad as well:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/721576
> 
> There are a variety of reports of the same panic at that bug on
> 2.6.32.y-, 2.6.38.y-, and 2.6.39-based kernels.  Passing "reboot=a,w"
> on the kernel command line avoids trouble for reporters.
> 
> Regards,
> Jonathan
> 
> [1] http://bugs.debian.org/626022

Thanks for the detailed report. I'm queuing it now.

Best regards,
Willy

