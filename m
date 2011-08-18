Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755547Ab1HRPVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 11:21:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:40891 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab1HRPVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 11:21:39 -0400
Subject: Re: pstore: change mutex locking to spin_locks
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Don Zickus <dzickus@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Luck, Tony" <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110818130447.GA1972@redhat.com>
References: <4e4568eb10165cbab6@agluck-desktop.sc.intel.com>
	 <20110817142225.8645fff7.akpm@linux-foundation.org>
	 <1313617679.2212.4.camel@laptop>  <20110818130447.GA1972@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 18 Aug 2011 17:26:43 +0200
Message-ID: <1313681203.2212.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 09:04 -0400, Don Zickus wrote:
> 
> Unfortunately, this plague is called ACPI4 (well APEI) 

Bah, ACPI4 is a running trainwreck, we should just boycot that horror..
OS vendors refusing to implement their drug induced crap should
hopefully give a signal.. then again you can never tell with those
chaps.

