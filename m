Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755736Ab1HROcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 10:32:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab1HROcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 10:32:51 -0400
Subject: Re: pstore: change mutex locking to spin_locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Don Zickus <dzickus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110818125849.GZ1972@redhat.com>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
	 <20110817142225.8645fff7.akpm@linux-foundation.org>
	 <20110818125849.GZ1972@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 16:37:51 +0200
Message-ID: <1313678271.2212.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 08:58 -0400, Don Zickus wrote:
> Probably the raw_spin_* stuff.  I think those purposely avoid the lockdep
> mechanisms. 

Nope, raw_spin_* is covered by lockdep just fine. Also anything
purposely avoiding lockdep is bound to be a piece of crap :-)

