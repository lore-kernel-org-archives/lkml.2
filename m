Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab2AaRjZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 12:39:25 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35669 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752270Ab2AaRjX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 12:39:23 -0500
Date: Tue, 31 Jan 2012 09:38:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steffen Persvold <sp@numascale.com>
Cc: Daniel J Blueman <daniel@numascale-asia.com>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org
Subject: Re: RCU qsmask !=0 warnings on large-SMP...
Message-ID: <20120131173859.GD2391@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F2070B9.2000104@numascale.com>
 <20120125213450.GJ2849@linux.vnet.ibm.com>
 <4F2086DA.4040203@numascale.com>
 <20120126015843.GN2849@linux.vnet.ibm.com>
 <4F216B85.7010208@numascale.com>
 <20120126192653.GC2437@linux.vnet.ibm.com>
 <4F2285E5.9050705@numascale.com>
 <20120129060921.GC17696@linux.vnet.ibm.com>
 <20120130161529.GA5118@linux.vnet.ibm.com>
 <4F2825D1.3030306@numascale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2825D1.3030306@numascale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12013117-7182-0000-0000-0000009DE0CE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 06:33:05PM +0100, Steffen Persvold wrote:
> On 1/30/2012 17:15, Paul E. McKenney wrote:
> []
> >>
> >>Hmmm...  I wonder if it waits for a grace period?
> >>
> >>If it cannot be made to work, I can probably put together some
> >>alternative diagnostics, but it will take me a day or three.
> >
> >Actually, another thing to try is "torture_type=rcu_bh" on the modprobe
> >line for rcutorture.  Also, it would be good to get a stack dump of the
> >hung process -- it might be hung for some other reason.
> 
> Paul,
> 
> Do not dwell more over this issue at the moment. I have indications
> that the inconsistency we're seeing is related to something else
> than the RCU code itself.

Thank you for letting me know!

							Thanx, Paul

