Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0IHWZa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 18:25:30 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:51330 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756281Ab0IHWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 18:25:25 -0400
To: John Drescher <drescherjm@gmail.com>
Cc: Damien Wyart <damien.wyart@free.fr>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35.*: horrible (exponential? >linear) slowdown to unusability (ACPI idle?)
References: <87zkvx2ese.fsf@spindle.srvr.nix>
	<20100906053255.GA23340@brouette> <87iq2gyllg.fsf@spindle.srvr.nix>
	<AANLkTi=ioyeBvN_yiHER7imi9tjGKH3E=jQCbO0NeO-z@mail.gmail.com>
From: Nix <nix@esperi.org.uk>
Emacs: Our Lady of Perpetual Garbage Collection
Date: Wed, 08 Sep 2010 23:25:22 +0100
In-Reply-To: <AANLkTi=ioyeBvN_yiHER7imi9tjGKH3E=jQCbO0NeO-z@mail.gmail.com> (John Drescher's message of "Wed, 8 Sep 2010 17:35:48 -0400")
Message-ID: <87eid3zxd9.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-z.dcc-servers-Metrics: spindle 1049; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Sep 2010, John Drescher spake thusly:
> I believe I have the same problem reported in your first post. Or at
> least a lot of the symptoms.
>
> http://forums.gentoo.org/viewtopic-t-842775-postdays-0-postorder-asc-start-0.html

Yeah, that looks mostly the same, though when I see it with
CONFIG_NO_HZ, I get an increasing slowdown to unusability, not instant
sloth as you do. (The WD GreenPower thing is a complete red herring, of
course: if that was the cause of the sloth, it would be slow in other
kernels too. I see this both on machines with -- non-buggy --
GreenPowers behind an Areca RAID array, and on machines with totally
different brands of drives. ToI is likewise a complete red herring.)
