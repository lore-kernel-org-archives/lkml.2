Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881Ab0CZDD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 23:03:27 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:43754 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300Ab0CZDDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 23:03:25 -0400
Date: Fri, 26 Mar 2010 12:02:08 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jamie Lokier <jamie@shareable.org>
Cc: Christoffer Dall <christofferdall@christofferdall.dk>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       containers <containers@lists.linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [C/R ARM][PATCH 3/3] c/r: ARM implementation of checkpoint/restart
Message-ID: <20100326030208.GA5815@linux-sh.org>
References: <1269219965-23923-1-git-send-email-christofferdall@christofferdall.dk> <1269219965-23923-4-git-send-email-christofferdall@christofferdall.dk> <20100323211843.GC19572@n2100.arm.linux.org.uk> <7d08b87d1003241348g347f092k1142318490e0bdcc@mail.gmail.com> <20100326024759.GN19308@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326024759.GN19308@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 02:47:59AM +0000, Jamie Lokier wrote:
> Christoffer Dall wrote:
> > >> We checkpoint whether the system is running with CONFIG_MMU or not and
> > >> require the same configuration for the system on which we restore the
> > >> process. It might be possible to allow something more fine-grained,
> > >> if it's worth the energy. Input on this item is also very welcome,
> > >> specifically from someone who knows the exact meaning of the end_brk
> > >> field.
> > >
> > > Processes which run on MMU and non-MMU CPUs are unlikely to be
> > > interchangable - the run time environments are quite different. ?I
> > > think this is a sane check.
> > >
> > thanks.
> 
> It's possible in principle to run many non-MMU binaries on MMU
> kernels, but I've never heard of anyone doing it.
> 
FDPIC supports running the same binaries with or without MMU depending on
your ABI, it's not really that uncommon, even if it's mostly just used
for prototyping.
