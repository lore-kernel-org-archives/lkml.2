Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760310Ab2CUUrb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:47:31 -0400
Received: from mail.vyatta.com ([76.74.103.46]:35750 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754052Ab2CUUra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:47:30 -0400
Date: Wed, 21 Mar 2012 13:47:25 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Knut Petersen <Knut_Petersen@t-online.de>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Torvalds <torvalds@linux-foundation.org>, arekm@maven.pl,
        Jared <nitro@legroom.net>, dilieto@lineone.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: override for PCI legacy power management
Message-ID: <20120321134725.222e9c07@nehalam.linuxnetplumber.net>
In-Reply-To: <CAErSpo67PEaZ6JuMUntWLfR8SUpQgZERD_cKV6rWd=FF0tZ6DQ@mail.gmail.com>
References: <4F69BE2E.7070903@t-online.de>
	<20120321083205.360a7a3b@nehalam.linuxnetplumber.net>
	<CAErSpo67PEaZ6JuMUntWLfR8SUpQgZERD_cKV6rWd=FF0tZ6DQ@mail.gmail.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 14:22:01 -0600
Bjorn Helgaas <bhelgaas@google.com> wrote:

> On Wed, Mar 21, 2012 at 9:32 AM, Stephen Hemminger
> <shemminger@vyatta.com> wrote:
> > Some BIOS's don't setup power management correctly (what else is
> > new) and don't allow use of PCI Express power control. Add a special
> > exception module parameter to allow working around this issue.
> > Based on slightly different patch by Knut Petersen.
> >
> > Reported-by: Arkadiusz Miskiewicz <arekm@maven.pl>
> > Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>
> 
> Is there a problem report URL you can include here?
> 
> It looks like this requires a user to figure out that he might be
> suffering from this problem, then use this module parameter to work
> around it.  How would a user figure that out?  Can we do it
> automatically to save him the trouble?

I am not a power management expert. Looks like a BIOS issue where the
BIOS has configured the device to disable power management but the
user wants to override that value. There is no method to determine
when the BIOS is broken versus when the BIOS setting is correct and
we should follow what it says.
