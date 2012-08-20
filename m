Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998Ab2HTPLO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:11:14 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:48952 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab2HTPLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:11:08 -0400
Date: Mon, 20 Aug 2012 08:09:50 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-ID: <20120820150950.GC2435@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120816131236.13013e1ec18b1f1074f6dc92@canb.auug.org.au>
 <20120816194651.GK2445@linux.vnet.ibm.com>
 <20120817105633.0aba80ddf7eb9523e04c264d@canb.auug.org.au>
 <20120817115019.GJ2438@linux.vnet.ibm.com>
 <20120820145404.f12977568303f4982ce89e8e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820145404.f12977568303f4982ce89e8e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12082015-7408-0000-0000-000007C31CFA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 02:54:04PM +1000, Stephen Rothwell wrote:
> Hi Paul,
> 
> On Fri, 17 Aug 2012 04:50:19 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >
> > Does the following help?
> 
> Yes, that fixes the warnings.  Please submit those two patches to the tip
> folks ASAP as I can't build the tip tree without them.

Will do.  Unless you tell me otherwise, with your Tested-by.

							Thanx, Paul

