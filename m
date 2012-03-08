Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524Ab2CHE0F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 23:26:05 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:48641 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754589Ab2CHE0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 23:26:04 -0500
Date: Wed, 7 Mar 2012 20:25:53 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Greg KH <greg@kroah.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] Ignore pre-1.1 ASPM quirking when ASPM is disabled
Message-ID: <20120307202553.50b6c91c@jbarnes-x220>
In-Reply-To: <20120307054859.GB7775@kroah.com>
References: <1331059309-4335-1-git-send-email-mjg@redhat.com>
	<20120307054859.GB7775@kroah.com>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.237.97.32 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 21:48:59 -0800
Greg KH <greg@kroah.com> wrote:

> On Tue, Mar 06, 2012 at 01:41:49PM -0500, Matthew Garrett wrote:
> > Right now we won't touch ASPM state if ASPM is disabled, except in
> > the case where we find a device that appears to be too old to
> > reliably support ASPM. Right now we'll clear it in that case, which
> > is almost certainly the wrong thing to do. The easiest way around
> > this is just to disable the blacklisting when ASPM is disabled.
> > 
> > Signed-off-by: Matthew Garrett <mjg@redhat.com>
> > Cc: stable@kernel.org
> 
> That's <stable@vger.kernel.org> if we want to get it right :)
> 
> Anyway, Jesse, this needs to get into 3.3-final to prevent
> regressions...

Any bz links to add to the changelog?  I'll fix up the stable cc when I
commit...

Jesse
