Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758785Ab0EXXmM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 19:42:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54897 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758575Ab0EXXmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 19:42:10 -0400
Date: Tue, 25 May 2010 01:42:21 +0200
From: Andi Kleen <andi@firstfloor.org>
To: john stultz <johnstul@us.ibm.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Brian Bloniarz <bmb@athenacr.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
Message-ID: <20100524234221.GA5907@gargoyle.fritz.box>
References: <4BF58B59.7080901@athenacr.com> <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com> <ce764b91-11b0-44a5-9cf9-96977652bbd5@default> <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com> <1274733566.2954.73.camel@localhost.localdomain> <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <b4a3fe9e-8646-4fb9-93e0-6953be7a0aa9@default> <1274743836.2954.104.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274743836.2954.104.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > As more and more systems become dependent on clocksource==tsc
> > and more and more people assume nanosecond-class measurements
> > are relatively accurate, I'd expect the accuracy of tsc_khz
> > to become more important.  While desktop users might bristle
> > at an extra second of boot delay, I'll bet many server
> > farm administrators would gladly pay that upfront cost
> > if they know an option exists.
> 
> Maybe something like a tsc_long_calibration=1 option would allow for
> this?  

On a system with synchronized TSC and multiple cores you could also simply do 
a longer calibration on another core in the background after a quick "fast
calibration"

-Andi
