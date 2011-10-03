Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1JCQkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:40:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29014 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab1JCQkS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:40:18 -0400
Date: Mon, 3 Oct 2011 18:35:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
Message-ID: <20111003163559.GA3957@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org> <m21uuxirxi.fsf@firstfloor.org> <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com> <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com> <1317656613.3375.78.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317656613.3375.78.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Matt Fleming wrote:
>
> Oh, are you referring to Oleg's email about the slow down under kvm?
> Yeah, admittedly that's a pretty clear indicator that something is wrong
> with the approach in this patch series.

Or there was something wrong with my testing, please recheck. I specially
mentioned I was surprised by the numbers. May be kvm, or lockdep...

Oleg.

