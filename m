Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab0JQKnA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 06:43:00 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33106 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab0JQKm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 06:42:59 -0400
Subject: Re: [tip:perf/core] x86, NMI: Rewrite NMI handler
From: Peter Zijlstra <peterz@infradead.org>
To: Don Zickus <dzickus@redhat.com>
Cc: mingo@redhat.com, hpa@zytor.com, ying.huang@intel.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
        linux-tip-commits@vger.kernel.org
In-Reply-To: <20101017004641.GB4140@redhat.com>
References: <1287195738-3136-4-git-send-email-dzickus@redhat.com>
	 <tip-e21f3e4957f4a55f546873605a5caa59556bb144@git.kernel.org>
	 <1287250157.1998.124.camel@laptop>  <20101017004641.GB4140@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 17 Oct 2010 12:42:43 +0200
Message-ID: <1287312163.1998.158.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-16 at 20:46 -0400, Don Zickus wrote:

> Hmm, well to his defense, he isn't adding DIE_NMI_IPI.  That code is
> already there.  He is just re-arranging it, making it look painfully
> obvious the die_chain probably isn't as efficient as it should be.
> 
> I think a bunch of us agree that we need to revamp the NMI notifier to
> make it less wasteful.  I was hoping we could do that in a separate patch
> that would be layered on top of Huangs.
> 
> Would you object to at least consider having this patch series in a
> work-in-progress git branch that we can build on top of, with the final
> outcome containing an nmi notifier that meets your expectations?

What's the point of keeping it in a git tree? Its just a few patches.

We've spend more time talking about this than it would take to actually
do the patch that kills DIE_NMI_IPI.
