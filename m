Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752442Ab1GTO7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 10:59:43 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:42665 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543Ab1GTO7m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 10:59:42 -0400
Date: Wed, 20 Jul 2011 07:59:39 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: RKK <kulkarni.ravi4@gmail.com>
Cc: kernelmail.jms@gmail.com, linux-kernel@vger.kernel.org, cmm@us.ibm.com
Subject: Re: Fw: RCU boot debug patch
Message-ID: <20110720145939.GB2352@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110719224142.GT2357@linux.vnet.ibm.com>
 <CAM=x7SbY8Z8jmarRougaJPxxR8gHi2MKtCUkq8Yi4JYCBo=JAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAM=x7SbY8Z8jmarRougaJPxxR8gHi2MKtCUkq8Yi4JYCBo=JAw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 10:57:38AM +0530, RKK wrote:
> Hi paul,
> 
> On Wed, Jul 20, 2011 at 4:11 AM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > Hello, Julie and Ravi,
> >
> > Although we arrived at a patch that worked for both of you, we never did
> > identify exactly which RCU callback (or other issue) that was causing
> > the problem.  It would be good to do this in case there is some other
> > problem lurking that might bite us in the future.  Mingming has therefore
> > put together the following diagnostic patch which should identify the
> > callbacks, please see below.
> >
> > So could you please run this and let us know what you find?  There should
> > at least be a message for artificial_callback().
> >
> 
>  Do i need to  apply this patch on today's Linus master or on -rc7 ?

Please do not use -rc7, as that would reproduce your hang.  Linus master
tree would be best, but -rc7 with the fix applied would work fine as well.

							Thanx, Paul
