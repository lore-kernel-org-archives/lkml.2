Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab0IFU1O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 16:27:14 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:35376 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab0IFU1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 16:27:08 -0400
To: Damien Wyart <damien.wyart@free.fr>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (ACPI idle?)
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette>
From: Nix <nix@esperi.org.uk>
Emacs: or perhaps you'd prefer Russian Roulette, after all?
Date: Mon, 06 Sep 2010 21:27:04 +0100
In-Reply-To: <20100906053255.GA23340@brouette> (Damien Wyart's message of "Mon, 6 Sep 2010 07:32:55 +0200")
Message-ID: <87aanu39ev.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=2 Fuz1=2 Fuz2=2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 Sep 2010, Damien Wyart told this:
> I think this is related to what has been discussed in this thread:
> http://lkml.org/lkml/2010/7/14/11

Quite possibly :/ though I'm on x86-64, not x86, and certainly don't
have kmemleak turne don.

> I've not seen the problem with 2.6.35.4 yet, and only once with
> 2.6.35.3. Zeno said it disappeared for him when he started to use
> 2.6.35-stable.

Argh.

> So if you can reproduce it quite easily, I guess bisection (even
> painful) will be the best way to get (hopefuly) an idea of where the
> problem might come from...

'Quite easily' is not quite true. It does not show up in qemu -kernel.
It does not show up if you boot straight to an emergency boot shell
in the initramfs (I was trying to avoid activating the RAID arrays).

So I guess it's a full-blown boot each time, which is made pointlessly
difficult by the fact that the rpc.mountd on my NFS server is acting up,
giving me -ESTALE half the time for an initial mount (??!!!) and thus
totally buggering up my client system whenever I reboot. So I may have
to debug *that* first. What fun.

But I'll get around to it.
