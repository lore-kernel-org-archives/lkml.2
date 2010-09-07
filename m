Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab0IGFgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:36:12 -0400
Received: from smtp-115-monday.nerim.net ([62.4.16.115]:59339 "EHLO
	maiev.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751162Ab0IGFgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:36:03 -0400
X-Greylist: delayed 86586 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Sep 2010 01:36:03 EDT
Date: Tue, 7 Sep 2010 07:36:00 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: Nix <nix@esperi.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.*: horrible (exponential? >linear) slowdown to
 unusability (ACPI idle?)
Message-ID: <20100907053600.GA2508@brouette>
References: <87zkvx2ese.fsf@spindle.srvr.nix>
 <20100906053255.GA23340@brouette>
 <87aanu39ev.fsf@spindle.srvr.nix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87aanu39ev.fsf@spindle.srvr.nix>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think this is related to what has been discussed in this thread:
> > http://lkml.org/lkml/2010/7/14/11

* Nix <nix@esperi.org.uk> [2010-09-06 21:27]:
> Quite possibly :/ though I'm on x86-64, not x86, and certainly don't
> have kmemleak turne don.

Yes, at first we were talking about x86 and kmemleak but leter on, the
problem seemed more related to x86-64 and the config_no_bootmem option.

> > So if you can reproduce it quite easily, I guess bisection (even
> > painful) will be the best way to get (hopefuly) an idea of where the
> > problem might come from...

> 'Quite easily' is not quite true. It does not show up in qemu -kernel.
> It does not show up if you boot straight to an emergency boot shell
> in the initramfs (I was trying to avoid activating the RAID arrays).

> So I guess it's a full-blown boot each time, which is made pointlessly
> difficult by the fact that the rpc.mountd on my NFS server is acting up,
> giving me -ESTALE half the time for an initial mount (??!!!) and thus
> totally buggering up my client system whenever I reboot. So I may have
> to debug *that* first. What fun.

Yes, but you seem to get it at each boot and immediately, which was
never my case (don't know about Zeno). With 2.6.35.3 I got it only once
in several days of uptimes and boots.

I hope your specific situation will help isolate the problem...

-- 
Damien Wyart
