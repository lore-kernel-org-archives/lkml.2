Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965421Ab2FBGyg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 02:54:36 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:3093 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965172Ab2FBGyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 02:54:35 -0400
Date: Sat, 2 Jun 2012 08:54:25 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Dean Nelson <dnelson@redhat.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: f71805f arch dependencies?
Message-ID: <20120602085425.5bb306ad@endymion.delvare>
In-Reply-To: <alpine.SOC.1.00.1206020925060.2992@math.ut.ee>
References: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee>
	<CAMuHMdXtZg7JJ18Ao+yLJ5s-vHt38Omgp=b4vOOFet870Buuzw@mail.gmail.com>
	<alpine.SOC.1.00.1206011610060.10517@math.ut.ee>
	<CAMuHMdVLkueZdpjht9kL9s9qKv=YT18AVTCoYDmJyKLD=KQ4dg@mail.gmail.com>
	<20120601220315.246ba5a5@endymion.delvare>
	<alpine.SOC.1.00.1206020925060.2992@math.ut.ee>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2 Jun 2012 09:27:51 +0300 (EEST), Meelis Roos wrote:
> > > Indeed, it seems commit 746cdfbf01c0a30d59f6e1b6942d432658d7c7cd
> > > ("hwmon: Avoid building drivers for powerpc that read/write ISA addresses")
> > > was a bit too limited...
> > 
> > I am fine extending that commit to other architectures. Now the
> > question is, do we just add SPARC64 to the exception list, or do we
> > restrict these drivers to X86? I know they are mostly used on X86, but
> > I have no proof they aren't used on other architectures. That's why
> > Dean and myself decided to play it safe at first and only exclude PPC.
> > 
> > Apparently other drivers (e.g. watchdog drivers) for similar chips are
> > limited to X86 so we might as well do the same here. And see if anybody
> > complains...
> > 
> > Meelis, do you feel like sending a patch, or do you prefer if I take
> > care of it?
> 
> I can send a patch in a couple of days, but I do not know either wihich 
> way is better.
> 
> What other architectures can use the ISA-IO style LPC - probably quite 
> several if hardware has been made (but it probably hasn't)?

I just don't know, this is the problem.

-- 
Jean Delvare
