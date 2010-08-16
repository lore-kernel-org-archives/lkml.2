Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab0HPPmV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 11:42:21 -0400
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:42117 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab0HPPmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 11:42:20 -0400
Date: Mon, 16 Aug 2010 08:42:18 -0700
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: BISECTED: 2.6.35 (and -git) fail to boot: APIC problems
Message-ID: <20100816154218.GB30251@ovro.caltech.edu>
References: <20100813193441.GD18691@ovro.caltech.edu>
 <m1y6cap5k6.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1y6cap5k6.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.0 (ovro.ovro.caltech.edu); Mon, 16 Aug 2010 08:42:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 13, 2010 at 02:26:49PM -0700, Eric W. Biederman wrote:
> "Ira W. Snyder" <iws@ovro.caltech.edu> writes:
> 
> > Hello Eric,
> >
> > I've recently tried to boot 2.6.35 (and -git) on one of my machines, and it
> > fails to boot. No messages are printed to the serial console. I have run git
> > bisect, and found that your commit cf7500c0ea133d is the cause.
> 
> This problem took a while to track down, but it should be fixed in the
> commit below.  Which linus merged today from the x86-urgent branch.
> 
> Thank you for the excellent bug report, and my apologies for missing
> this the first time around.
> 
> Can you please verify the commit below fixes your problem?
> 

Thanks Eric!

Commit 5989cd6a1cbf86 fixes my problem. It looks like Linus pulled this
patch very soon after I had updated my -git tree. I guess this was just
a case of bad timing. :)

Thanks again for responding so quickly!
Ira
