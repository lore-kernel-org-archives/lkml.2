Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932630Ab1JCVAm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 17:00:42 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:57854 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757594Ab1JCU6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:58:50 -0400
Subject: Re: [RFC][PATCH 0/5] Signal scalability series
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org, Tony Luck <tony.luck@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        David Mosberger-Tang <davidm@egauge.net>
In-Reply-To: <20111003163559.GA3957@redhat.com>
References: <1317395577-14091-1-git-send-email-matt@console-pimps.org>
	 <m21uuxirxi.fsf@firstfloor.org>
	 <1317461738.3375.46.camel@mfleming-mobl1.ger.corp.intel.com>
	 <CA+55aFyscb=PcUDrEUhFbH89+W-KYEKrqKHeNN3dqmZD1GF_Hw@mail.gmail.com>
	 <1317656613.3375.78.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20111003163559.GA3957@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 Oct 2011 21:58:40 +0100
Message-ID: <1317675520.3375.82.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-03 at 18:35 +0200, Oleg Nesterov wrote:
> On 10/03, Matt Fleming wrote:
> >
> > Oh, are you referring to Oleg's email about the slow down under kvm?
> > Yeah, admittedly that's a pretty clear indicator that something is wrong
> > with the approach in this patch series.
> 
> Or there was something wrong with my testing, please recheck. I specially
> mentioned I was surprised by the numbers. May be kvm, or lockdep...

No, I don't think there was anything wrong with your testing method. I
ran your command-line under Qemu and saw similar results - with the
patches applied the single-threaded case slows down (not by 50%, it
looks more like 25%, but that's still unacceptable and not at all what I
had anticipated).

-- 
Matt Fleming, Intel Open Source Technology Center

