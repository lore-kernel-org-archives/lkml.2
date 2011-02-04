Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab1BDWAY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 17:00:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58891 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab1BDWAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 17:00:22 -0500
Date: Fri, 4 Feb 2011 23:00:07 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: John Villalovos <jvillalo@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "John L. Villalovos" <john.l.villalovos@intel.com>, prarit@redhat.com
Subject: Re: [PATCH 1/1] x86, apic: Make "broken BIOS!!" messages unique
Message-ID: <20110204220007.GA6052@elte.hu>
References: <20110204174831.GA10370@intel-s3eb1-02.lab.bos.redhat.com>
 <4D4C4C4D.40106@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D4C4C4D.40106@zytor.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 02/04/2011 09:48 AM, John Villalovos wrote:
> > x86, apic: Make "broken BIOS!!" messages unique
> > 
> > There are five identical "broken BIOS!!" messages.  This patch makes each
> > message unique so that it is easier to determine which message was actually
> > printed.
> > 
> > The 'inconceivable' messages are because it should not be possible to reach
> > those code paths.
> 
> How about labelling these "MPBIOS" or so, too?

Yeah.

Also, the messages do not need to shout i suspect - the '!!' can be removed as well.

Thanks,

	Ingo
