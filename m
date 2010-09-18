Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab0IRAAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 20:00:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46374 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab0IRAAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 20:00:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oBA58OmXS5IpiXJSnNCKqs4B87uB6FPgsjyCi+QK+Cw4Y0NhRRPuM7io11sdCbhvdH
         MZ2tky3XOl6x2x/LAOfbrbwYcisbe61/RR0xaH6LDHFNyr5NiYdMsCsL4OW5bwwUNKRj
         lFg/xy1WmWXDZZn7PK6s0KJ4UleY2NkbuZWsE=
Subject: Re: [git pull] FireWire fixes
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <4C93FCC7.9040406@s5r6.in-berlin.de>
References: <tkrat.b186ea3830d71c45@s5r6.in-berlin.de>
	 <1284764773.2804.7.camel@maxim-laptop> <4C93FCC7.9040406@s5r6.in-berlin.de>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 18 Sep 2010 02:00:09 +0200
Message-ID: <1284768009.2741.3.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-09-18 at 01:41 +0200, Stefan Richter wrote: 
> Maxim Levitsky wrote:
> > Running new stack on the laptop + old stack on the desktop gave me about
> > 18-30 Mbit/s speeds varying all the time.
> > Running both with the new stack results in corrupted packets and sftp
> > exits immediately.
> 
> firewire-net, the IP over 1394 driver, is still marked as experimental not
> because somebody forgot to remove that mark but because we mean it.  But so is
> its older counterpart, eth1394.  Both eth1394 and firewire-net are chronically
>  underused and undermaintained.
I sure do understand it!
I just did another round of testing and report the results.

Do you have an idea what could cause such low speeds?


> 
> > The problems I so hoped to be fixed in new stack still persist:
> > 
> > Cable disconection/reconnection still results in the link loss till
> > ifconfig down/up.
> > 
> > Suspend/resume also results in the link loss.
> 
> Sounds like something that shouldn't be too hard to fix by anybody who can
> spare the time.  Surely a higher-level problem somewhere in firewire-net.
> 
> > Driver still has panics on some occasions.
> 
> At the moment I suspect that this OTOH might not be a firewire-net problem but
> possibly a race in firewire-ohci which is only triggered by workload as
> firewire-net imposes it (heavy AT context usage).
Thanks for information!

Best regards,
Maxim Levitsky


