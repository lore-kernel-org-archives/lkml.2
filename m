Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0INRsa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 13:48:30 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:38400 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751763Ab0INRs3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 13:48:29 -0400
Date: Tue, 14 Sep 2010 19:48:14 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Andi Kleen <andi@firstfloor.org>
Cc: Don Zickus <dzickus@redhat.com>, Huang Ying <ying.huang@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC 5/6] x86, NMI, Add support to notify hardware error with
 unknown NMI
Message-ID: <20100914174814.GC3822@elte.hu>
References: <45864.91.60.148.9.1284474680.squirrel@www.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45864.91.60.148.9.1284474680.squirrel@www.firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 1.0
X-ELTE-SpamLevel: s
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=1.0 required=5.9 tests=BAYES_50 autolearn=no SpamAssassin version=3.2.5
	1.0 BAYES_50               BODY: Bayesian spam probability is 40 to 60%
	[score: 0.4947]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Some One <some@where> stripped out all quoted identities and wrote:

> >
> > The proper approach would be not to add hacks to the NMI code but to 
> > implement southbridge drivers - which would also have NMI callbacks.
> 
> BTW southbridges do less and less regarding PCI.

Except WICTCR.

> > These are unchartered waters, but variance in that space is reducing 
> > systematically so it would be worth a shot.
> 
> You don't really need special drivers for AER [...]

On the contrary, we need proper driverization for _everything_ new. 
Embedded x86 is here to stay, so we are abstracting away each and every 
bit of the platform. See struct x86_ops for a highlevel platform driver 
- but a more specific, southbridge-encompassing driver framework can be 
created too.

Thanks,

	Ingo
