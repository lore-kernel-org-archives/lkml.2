Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab1EFMix (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:38:53 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:39857 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752258Ab1EFMiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:38:52 -0400
Date: Fri, 6 May 2011 14:28:30 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>,
        kernel@avr32linux.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] avr32: add some more at91 to cpu.h definition
Message-ID: <20110506122830.GJ11267@game.jcrosoft.org>
References: <1304680123-20218-1-git-send-email-nicolas.ferre@atmel.com>
 <1304683480.3025.2.camel@hcegtvedt.norway.atmel.com>
 <4DC3EA35.5030709@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DC3EA35.5030709@atmel.com>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 16994614669147482988
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:31 Fri 06 May     , Nicolas Ferre wrote:
> Le 06/05/2011 14:04, Hans-Christian Egtvedt :
> > On Fri, 2011-05-06 at 13:08 +0200, Nicolas Ferre wrote:
> >> Somme common drivers will need those at91 cpu_is_xxx() definitions.
> >> Those definitions are already in Linus' tree so if we want to use them
> >> in common drivers, we will need them in AVR32 cpu.h file.
> >>
> >> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > 
> > Will you push this update for 2.6.39? I don't have anything for Linus
> > right now.
> 
> Ah, Linus has just pulled from our tree...
> Maybe we can wait a few days to see if some fixes have to be pushed
> upstream before -final...
> 
> > Acked-by: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
> > with one comment...
I've a bug fix for udc but nothing more
maybe map_io fix can go now

Best Regards,
J.
