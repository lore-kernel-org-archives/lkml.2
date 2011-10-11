Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102Ab1JKJM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 05:12:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35443 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753974Ab1JKJM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 05:12:27 -0400
Subject: Re: [PATCH v2 2/3] Mutually exclude cpu online and
 suspend/hibernate
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Tejun Heo <tj@kernel.org>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, rjw@sisk.pl,
        bp@amd64.org, pavel@ucw.cz, len.brown@intel.com, mingo@elte.hu,
        akpm@linux-foundation.org, suresh.b.siddha@intel.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        rdunlap@xenotime.net, vatsa@linux.vnet.ibm.com, ashok.raj@intel.com,
        tigran@aivazian.fsnet.co.uk, tglx@linutronix.de, hpa@zytor.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
In-Reply-To: <20111010170027.GD8100@google.com>
References: <20111010123102.15067.23128.stgit@srivatsabhat.in.ibm.com>
	 <20111010123242.15067.48238.stgit@srivatsabhat.in.ibm.com>
	 <4E92E8E0.4090004@linux.vnet.ibm.com>  <20111010170027.GD8100@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 11:18:34 +0200
Message-ID: <1318324714.14400.74.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 10:00 -0700, Tejun Heo wrote:

> On Mon, Oct 10, 2011 at 06:15:20PM +0530, Srivatsa S. Bhat wrote:
> > Would it be better to hook into the suspend/hibernate notifiers and
> > use them to exclude cpu hotplug from suspend/hibernate, instead of
> > trying to take pm_mutex lock like this?
> 
> If this change is determined to be necessary, I think it would be
> better to make it explicit.  Exclusion through callbacks often makes
> the locking just more obscure.

Agreed.

