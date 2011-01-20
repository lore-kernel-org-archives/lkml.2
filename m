Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359Ab1ATLZ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:25:57 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:41210 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755153Ab1ATLZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:25:56 -0500
Date: Thu, 20 Jan 2011 12:25:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Shaohua Li <shaohua.li@intel.com>
Cc: "Anvin, H Peter" <h.peter.anvin@intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        "Lu, Hongjiu" <hongjiu.lu@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Linux 2.6.38-rc1 doesn't boot
Message-ID: <20110120112541.GA23661@elte.hu>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <20110119073905.GA1652@gentoo.trippels.de>
 <20110119074902.GA1670@gentoo.trippels.de>
 <1295424766.1949.879.camel@sli10-conroe>
 <4D36A759.60704@intel.com>
 <20110119090904.GA4927@elte.hu>
 <1295489286.1949.882.camel@sli10-conroe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295489286.1949.882.camel@sli10-conroe>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Shaohua Li <shaohua.li@intel.com> wrote:

> it's not a build failure, without it, my i386 kernel can't boot
> actually.

Please try hpa's patch in this thread on top of very latest (today's) -git or latest 
-tip:

   http://people.redhat.com/mingo/tip.git/README

Does that result in a booting system? That way we can avoid most of the linker 
script madness.

Thanks,

	Ingo
