Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2GDOyL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 10:54:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44423 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753325Ab2GDOyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 10:54:06 -0400
Message-ID: <1341413691.18786.0.camel@lappy>
Subject: Re: rcu: BUG: spinlock recursion on CPU#3, trinity-child19/5970
From: Sasha Levin <levinsasha928@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 04 Jul 2012 16:54:51 +0200
In-Reply-To: <20120702145927.GD2508@linux.vnet.ibm.com>
References: <1340964584.2936.40.camel@lappy>
	 <20120629172320.GA2416@linux.vnet.ibm.com> <1341006040.26928.4.camel@lappy>
	 <1341225139.23484.4.camel@twins> <20120702113541.GI2907@linux.vnet.ibm.com>
	 <1341230352.23484.7.camel@twins> <1341234773.2958.4.camel@lappy>
	 <20120702133334.GA2508@linux.vnet.ibm.com>
	 <20120702142252.GA22868@linux.vnet.ibm.com> <1341239813.2958.7.camel@lappy>
	 <20120702145927.GD2508@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-02 at 07:59 -0700, Paul E. McKenney wrote:
> On Mon, Jul 02, 2012 at 04:36:53PM +0200, Sasha Levin wrote:
> > Looks like its running fine for a bit now (~10 min). I'll ping if
> > anything changes, but on the other tests it has usually failed at this
> > point.
> If testing goes well (both yours and mine), I will be submitting this
> as urgent, since it is a 3.5 regression.  If they don't take it, I will
> queue it for 3.6.

2 days later, and this didn't reproduce. I think we can say it's solved.


