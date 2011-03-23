Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab1CWTXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:23:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53328 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756578Ab1CWTXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:23:52 -0400
Date: Wed, 23 Mar 2011 20:23:38 +0100
From: Borislav Petkov <bp@amd64.org>
To: Giorgio <mywing81@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@brodo.de" <linux@brodo.de>,
        "dougthompson@xmission.com" <dougthompson@xmission.com>,
        "mchehab@redhat.com" <mchehab@redhat.com>
Subject: Re: Machine Check Exception and cpufreq
Message-ID: <20110323192338.GE22652@aftab>
References: <AANLkTim3gpBUtDQ=WnLRjzuwpNe=+m4wLK=maS1tLc8U@mail.gmail.com>
 <20110322133101.GB24006@gere.osrc.amd.com>
 <AANLkTimz0GR7HXgY5jxogfkNyJ2iVYWJGHRhsZtO4T+A@mail.gmail.com>
 <AANLkTikDqUptK8XdPpAGYKFskSL7ugfoh-VjNzyXU_3q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikDqUptK8XdPpAGYKFskSL7ugfoh-VjNzyXU_3q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 03:02:01PM -0400, Giorgio wrote:
> 2011/3/22 Giorgio <mywing81@gmail.com>:
> > 2011/3/22 Borislav Petkov <bp@amd64.org>:
> >> this is very interesting. Question: is it possible to retest with
> >> a newer kernel from upstream (say 2.6.38) to see whether the issue
> >> persists? I'd like to rule out the possibility that powernow-k8 is
> >> not causing any trouble which has been fixed in newer kernels in the
> >> meantime.
> >>
> >> Thanks.
> >
> > Hello Borislav,
> >
> > thanks for your quick reply. Yes, I only tested it with the stock
> > 2.6.32 kernel shipped with Ubuntu 10.04, but I will download the
> > latest stable kernel from kernel.org (2.6.38) and test again. I'll
> > come back to you in the following days. Regards,
> 
> Borislav,
> 
> I tested again with 2.6.38 kernel: the system was stressed for several
> hours with various activities (compiling, copying data back and forth
> from two hard drives, encoding/decoding video streams, etc) but I was
> not able to reproduce the problem, so I guess it has been fixed.
> If you're interested here's the info I collected with 2.6.38:
> 
> http://mywing.altervista.org/tmp/info-2.6.38.log

Great. It's either fixed or latest powernow-k8 changes timings so as not
to trigger it anymore, because your issue looks like the chipset could
by doing something fishy with CRC during Pstate transitions.

If it happens again, try whether upgrading your BIOS solves it (although
I'm pretty sceptical about getting newer BIOS for such an old board :-) ).

> I found a similar report on the web, I don't know if this could be related:
> 
> http://www.spinics.net/lists/cpufreq/msg01922.html

Nah, that's another issue.

Thanks for testing!

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
