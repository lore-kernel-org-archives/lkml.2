Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656Ab1JBNsO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 09:48:14 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58132 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab1JBNsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 09:48:06 -0400
Date: Sun, 2 Oct 2011 15:48:02 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Avi Kivity <avi@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>, Robert Richter <robert.richter@amd.com>,
        "x86@kernel.org" <x86@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "ying.huang@intel.com" <ying.huang@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "jeremy@goop.org" <jeremy@goop.org>
Subject: Re: [V6][PATCH 4/6] x86, nmi:  add in logic to handle multiple events and unknown NMIs
Message-ID: <20111002134802.GH7761@one.firstfloor.org>
References: <1316805435-14832-1-git-send-email-dzickus@redhat.com> <1316805435-14832-5-git-send-email-dzickus@redhat.com> <20110928103140.GD6063@erda.amd.com> <20110928123720.GL5795@redhat.com> <4E8837D4.5040607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8837D4.5040607@redhat.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Second, I wanted to use NMIs as a way of waking up a vcpu sleeping with 
> interrupts disabled (in the context of Jeremy's paravirt spinlock 
> patches).  Looks like we'll have to use paravirtualization for that.

Just use a mode of perf that doesn't use NMIs.
Interrupt off profiling is rarely needed if at all on modern kernels.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
