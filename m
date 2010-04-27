Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab0D0E1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 00:27:50 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:38036 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751521Ab0D0E1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 00:27:48 -0400
Date: Mon, 26 Apr 2010 21:27:44 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Miles Lane <miles.lane@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       Eric Paris <eparis@redhat.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>, nauman@google.com,
       eric.dumazet@gmail.com, netdev@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] RCU: don't turn off lockdep when find suspicious
 rcu_dereference_check() usage
Message-ID: <20100427042744.GD2510@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100422145640.GB3228@redhat.com>
 <20100422160144.GC2524@linux.vnet.ibm.com>
 <h2xa44ae5cd1004230550uf734c89eo2b1d1945d446068c@mail.gmail.com>
 <20100423194255.GE2589@linux.vnet.ibm.com>
 <m2xa44ae5cd1004231559hcf90671asf146a43b4748c2c3@mail.gmail.com>
 <20100425023455.GM2440@linux.vnet.ibm.com>
 <w2sa44ae5cd1004250849q73704370vc6af935c70db9b73@mail.gmail.com>
 <p2ga44ae5cd1004251320j55d23ba7ua0fa14497f623d76@mail.gmail.com>
 <20100426160925.GD2529@linux.vnet.ibm.com>
 <m1hbmydpup.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1hbmydpup.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 26, 2010 at 11:35:10AM -0700, Eric W. Biederman wrote:
> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> 
> > Eric Dumazet traced these down to a commit from Eric Biederman.
> >
> > If I don't hear from Eric Biederman in a few days, I will attempt a
> > patch, but it would be more likely to be correct coming from someone
> > with a better understanding of the code.  ;-)
> 
> I already replied.
> 
> http://lkml.org/lkml/2010/4/21/420

You did indeed!!!  This experience is giving me an even better appreciation
of the maintainers' ability to keep all their patches straight!

I will put together something based on your suggestion.

							Thanx, Paul
