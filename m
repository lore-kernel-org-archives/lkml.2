Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752130Ab1GMVX2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:23:28 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:34275 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818Ab1GMVX1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:23:27 -0400
Date: Wed, 13 Jul 2011 14:23:15 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Julie Sullivan <kernelmail.jms@gmail.com>
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>, kulkarni.ravi4@gmail.com
Subject: Re: PROBLEM: 3.0-rc kernels unbootable since -rc3
Message-ID: <20110713212315.GE2355@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110710214639.GP6014@linux.vnet.ibm.com>
 <CAAVPGOMafp_+45X=7asHe=MqaHY8CiJYsf2GZ3qOPrWpjctHVQ@mail.gmail.com>
 <20110710231449.GQ6014@linux.vnet.ibm.com>
 <CAAVPGOMSprJSkzziH6hJv9PweOONzsMaRZEK2ZSrV3xFBReTPw@mail.gmail.com>
 <20110711214301.GP2245@linux.vnet.ibm.com>
 <CAAVPGOOJ0NEWqF2w9zCLC1bpXeA_TwzenNo-a4kvR3tcbewnNw@mail.gmail.com>
 <20110712212920.GQ2326@linux.vnet.ibm.com>
 <CAAVPGOPnHb0E=vutOEQwqsUTo-wrj6_-dEv7tW096yyppMgWcw@mail.gmail.com>
 <20110712220036.GR2326@linux.vnet.ibm.com>
 <CAAVPGONXoGcyeqdniWxRpsKCXf+PRQJeSfOUXgaB6d9ZyzdnCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVPGONXoGcyeqdniWxRpsKCXf+PRQJeSfOUXgaB6d9ZyzdnCA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 13, 2011 at 09:57:43PM +0100, Julie Sullivan wrote:
> >> Indeed this works, applied to a clean v3.0-rc4  (!CONFIG_RCU_BOOST 64-bit build)
> >
> > Woo-hoo!!!  ;-)
> >
> > I have added your Tested-by and will push it out for -next testing.
> >
> >> Great job, Paul, thanks for all your efforts.
> >> I'll test it tomorrow too on -rc5, 6 and 7 (out of time for tonight)
> >
> > Thinking good thoughts for the other -rc releases, and again thank you
> > very much for your testing!
> >
> > Ravi, could you please test to make sure that it works for you?
> >
> >                                                        Thanx, Paul
> >
> 
> Just quickly confirming - this patch also works just as well with
> -rc5, -rc6 and -rc7 my end.

Very good, thank you again!!!

							Thanx, Paul
