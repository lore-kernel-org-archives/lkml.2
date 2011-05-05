Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753337Ab1EEMLN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 08:11:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:59404 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751689Ab1EEMLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 08:11:12 -0400
Date: Thu, 5 May 2011 14:10:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Samuel <chris@csamuel.org>
Cc: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, setup: When probing memory with e801, use
 ax/bx as a pair
Message-ID: <20110505121059.GA31473@elte.hu>
References: <1303566747.12067.10.camel@localhost.localdomain>
 <201104261450.15786.chris@csamuel.org>
 <20110426081237.GD806@elte.hu>
 <201105052157.06317.chris@csamuel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105052157.06317.chris@csamuel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Chris Samuel <chris@csamuel.org> wrote:

> On Tue, 26 Apr 2011 06:12:37 PM Ingo Molnar wrote:
> 
> > Just asking, does the box now boot to user-space, or are there
> > other  regressions left?
> 
> Final update on this - I can now boot all the way to userspace
> successfully using an unpatched 2.6.39-rc6 with the parameters:
> 
> noapic scsi_mod.scan=sync
> 
> So I'm really happy, thanks so much to everyone for their help!

Thanks for the update!

Note that the noapic and the scsi-sync-scan boot parameter suggests that 
there's two regressions remaining.

The stock kernel wont boot - you can work it around via boot options but most 
users wont be able to do that.

Thanks,

	Ingo
