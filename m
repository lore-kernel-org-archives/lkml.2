Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1GNToW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 15:44:22 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:48546 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193Ab1GNToV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 15:44:21 -0400
Date: Thu, 14 Jul 2011 20:44:11 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Hylands <dhylands@gmail.com>
Cc: naveen yadav <yad.naveen@gmail.com>, kernelnewbies@nl.linux.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: ARM cortex A9 feature
Message-ID: <20110714194411.GA8942@n2100.arm.linux.org.uk>
References: <CAJ8eaTzLmSTSMOY-0Xg0tE-DEbZ6RNA+uh70Dn3K5CbrjQsEiA@mail.gmail.com> <CABi1daHh7cgyhJ4c3zo+jSUY4uzbFtihtgw0Q2Mcrndno_gcTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABi1daHh7cgyhJ4c3zo+jSUY4uzbFtihtgw0Q2Mcrndno_gcTA@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 09:56:34AM -0700, Dave Hylands wrote:
> Hi Naveen,
> 
> On Wed, Jul 13, 2011 at 11:26 PM, naveen yadav <yad.naveen@gmail.com> wrote:
> > Hi All,
> >
> > I am reading ARM cortex a9 manual and got few question in mind.
> >
> > 1. Where I need strong order type memory ? any sample example is very helpfull.
> 
> Often when dealing with hardware, you need to ensure that when your code does:
> 
> reg1 = val1;
> reg2 = val2;
> 
> that these writes actually occur in the order that the code issues
> them. Using volatile pointers will get the compiler to not reorder the
> instructions, but you still need the writes to hit the hardware in the
> same order that they were issued. Using strongly ordered memory is one
> way to achieve that.

Note that device memory also gives that an ordering guarantee too.
