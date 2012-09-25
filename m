Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753482Ab2IYShH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 14:37:07 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:35504 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab2IYShF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 14:37:05 -0400
Date: Tue, 25 Sep 2012 11:36:54 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120925183654.GI2502@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120922212735.GG2934@linux.vnet.ibm.com>
 <20120923002105.GA1112@linux.vnet.ibm.com>
 <505EA09B.6040105@gmail.com>
 <CAFTL4hwqzS8iO2zOOGaizzMtT85MJExTxEgGbponJ4_gfv0nwA@mail.gmail.com>
 <5060E31B.3070203@gmail.com>
 <5060E498.7030003@gmail.com>
 <CAFTL4hzVSBkcDRnzvpmXyBHqydqy=nJxdMtjUHrvR8MwN_M0jQ@mail.gmail.com>
 <5060E863.6020006@gmail.com>
 <20120925120549.GC2310@somewhere.redhat.com>
 <5061F7C7.7060107@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5061F7C7.7060107@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092518-7182-0000-0000-000002B0B620
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 08:28:23PM +0200, Sasha Levin wrote:
> On 09/25/2012 02:06 PM, Frederic Weisbecker wrote:
> > Sasha, sorry to burden you with more testing request.
> > Could you please try out this new branch? It includes some fixes after Wu Fenguang and
> > Dan Carpenter reports (not related to your warnings though) and a patch on the top
> > of the pile to ensure I diagnosed well the problem, which return immediately from
> > rcu_user_*() APIs if we are in an interrupt.
> > 
> > This way we'll have a clearer view. I also would like to know if there are other
> > problems with the rcu user mode.
> > 
> > Thanks!
> 
> Alrighty, I don't see any warnings anymore.
> 
> I'll keep everything running just in case.

Very good news!!!  Thank you both!!!

							Thanx, Paul

