Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab1EUNSs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 09:18:48 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:55540 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437Ab1EUNSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 09:18:47 -0400
Date: Sat, 21 May 2011 06:18:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@elte.hu
Subject: Re: [tip:core/rcu] Revert "rcu: Decrease memory-barrier usage
 based on semi-formal proof"
Message-ID: <20110521131844.GE2271@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <tip-80d02085d99039b3b7f3a73c8896226b0cb1ba07@git.kernel.org>
 <4DD6D746.6070107@kernel.org>
 <20110520224250.GL2366@linux.vnet.ibm.com>
 <4DD6F4A2.1070401@kernel.org>
 <20110520231428.GN2366@linux.vnet.ibm.com>
 <4DD6F64C.3030402@kernel.org>
 <20110520234923.GQ2366@linux.vnet.ibm.com>
 <4DD70120.9090801@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD70120.9090801@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 05:02:40PM -0700, Yinghai Lu wrote:
> On 05/20/2011 04:49 PM, Paul E. McKenney wrote:
> > On Fri, May 20, 2011 at 04:16:28PM -0700, Yinghai Lu wrote:
> ...
> >>
> >> the same one i sent out before, but let DEBUG_LOCKING_API_SELFTESTS disabled.
> > 
> > OK, just to make sure I understand...  You are compiling exactly the
> > same kernel source tree with exactly the same .config, just with two
> > different versions of gcc, correct?
> yes.
> > 
> > If so, it is quite possible that the slow one is the correct one.  :-/
> yeah, new version always have problem.
> 
> looks like opensuse11.3 has 4.5.0 and fedora14 has 4.5.1

OK, so fedora14 is the fast one (4.5.1) and opensuse11.3 is the slow
one (4.5.0), correct?

							Thanx, Paul
