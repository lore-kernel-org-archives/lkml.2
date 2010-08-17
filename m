Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0HQG2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 02:28:19 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:43241 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab0HQG2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 02:28:18 -0400
X-Originating-Ip: 216.16.235.2
Date: Tue, 17 Aug 2010 02:28:01 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org
Subject: Re: compiler warnings in 2.6.35.2
Message-ID: <20100817062801.GA24978@foursquare.net>
References: <20100817021252.GA17647@foursquare.net> <20100817053456.GA32714@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100817053456.GA32714@liondog.tnic>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 07:34:56AM +0200, Borislav Petkov wrote:
> From: Chris Frey <cdfrey@foursquare.net>
> Date: Mon, Aug 16, 2010 at 10:12:52PM -0400
> 
> >   CC      mm/swap.o
> > In file included from include/linux/kobject.h:21,
> >                  from include/linux/sched.h:91,
> >                  from mm/swap.c:17:
> > include/linux/sysfs.h:183: warning: parameter has incomplete type
> > /home/cdfrey/kernel/git/linux/arch/x86/include/asm/cpufeature.h: In function `__static_cpu_has':
> > /home/cdfrey/kernel/git/linux/arch/x86/include/asm/cpufeature.h:315: warning: asm operand 1 probably doesn't match constraints
> 
> Which compiler version are you using?

GCC 3.3

- Chris

