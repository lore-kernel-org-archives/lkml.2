Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533Ab1IGMFd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 08:05:33 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54540 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1IGMFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 08:05:24 -0400
Date: Wed, 7 Sep 2011 11:47:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Frank Rowand <frank.rowand@am.sony.com>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@tglx.de>,
        Venkatesh Pallipadi <venki@google.com>
Subject: Re: [ANNOUNCE] 3.0.1-rt11
Message-ID: <20110907104747.GA29282@n2100.arm.linux.org.uk>
References: <1313232790.25267.7.camel@twins> <4E559039.8060209@am.sony.com> <20110826235507.GJ2342@linux.vnet.ibm.com> <4E66DCAB.8090801@am.sony.com> <alpine.LFD.2.02.1109071115410.2723@ionos> <20110907104633.GR6619@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907104633.GR6619@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 11:46:33AM +0100, Russell King - ARM Linux wrote:
> I think we had this reported before and I got to the bottom of it - the
> platform was doing something it shouldn't.  I don't remember the details,
> maybe when all the emails come through I can see the original bug report
> I'll remember.

Or maybe I won't because it was never posted to an ARM mailing list.
So I've no idea what the real bug report is about or what has already
been discussed.
