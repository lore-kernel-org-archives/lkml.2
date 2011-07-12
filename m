Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911Ab1GLWA6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 18:00:58 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:51153 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab1GLWA5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 18:00:57 -0400
Date: Tue, 12 Jul 2011 15:00:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>, kulkarni.ravi4@gmail.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110712220036.GR2326@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110710173530.GA16954@linux.vnet.ibm.com>
 <CAAVPGOPAx-oLZct9u2Kq3uQ4W2GwJFYUGgw3h=M_Y4_wv7b51w@mail.gmail.com>
 <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <CAAVPGOMSprJSkzziH6hJv9PweOONzsMaRZEK2ZSrV3xFBReTPw@mail.gmail.com>
 <20110711214301.GP2245@linux.vnet.ibm.com>
 <CAAVPGOOJ0NEWqF2w9zCLC1bpXeA_TwzenNo-a4kvR3tcbewnNw@mail.gmail.com>
 <20110712212920.GQ2326@linux.vnet.ibm.com>
 <CAAVPGOPnHb0E=vutOEQwqsUTo-wrj6_-dEv7tW096yyppMgWcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVPGOPnHb0E=vutOEQwqsUTo-wrj6_-dEv7tW096yyppMgWcw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 10:49:22PM +0100, Julie Sullivan wrote:
> >
> > If this is the correct one, then the upstreamable patch I sent recently
> > (https://lkml.org/lkml/2011/7/12/313) should also work.  Famous last
> > words...
> >
> >                                                        Thanx, Paul
> 
> 
> Indeed this works, applied to a clean v3.0-rc4  (!CONFIG_RCU_BOOST 64-bit build)

Woo-hoo!!!  ;-)

I have added your Tested-by and will push it out for -next testing.

> Great job, Paul, thanks for all your efforts.
> I'll test it tomorrow too on -rc5, 6 and 7 (out of time for tonight)

Thinking good thoughts for the other -rc releases, and again thank you
very much for your testing!

Ravi, could you please test to make sure that it works for you?

							Thanx, Paul
