Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab2HHHAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 03:00:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49431 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab2HHHA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 03:00:29 -0400
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to
 bnx2-mips-09-6.2.1b
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: David Miller <davem@davemloft.net>, albcamus@gmail.com, chris@arachsys.com,
        mchan@broadcom.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
In-Reply-To: <20120808064959.GB15255@1wt.eu>
References: <20120713130405.GS13885@arachsys.com>
	 <CANE52KgHpmR7qCUUf3ZiMeskCitcAiMzzdARzy3a4RpKb73_Gg@mail.gmail.com>
	 <20120807.225800.1450928472652058111.davem@davemloft.net>
	 <20120808061758.GA15255@1wt.eu>
	 <1344407272.28967.214.camel@edumazet-glaptop>
	 <20120808064959.GB15255@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Aug 2012 09:00:23 +0200
Message-ID: <1344409223.28967.217.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-08 at 08:49 +0200, Willy Tarreau wrote:
> Hi Eric,
> 
> On Wed, Aug 08, 2012 at 08:27:52AM +0200, Eric Dumazet wrote:
> > On Wed, 2012-08-08 at 08:17 +0200, Willy Tarreau wrote:
> > 
> > > 
> > > Well, if the drivers provided with the kernel don't work out of the box
> > > anymore, maybe we should also move them to a separate repository. All it
> > > is going to do otherwise is to cause invalid bug reports because users
> > > don't understand why using the latest driver does not work.
> > > 
> > > That way it would be clear that an in-kernel driver has to be self-sustaining
> > > to be maintainable, otherwise it has nothing to do there.
> > 
> > People compiling their own kernels are supposed to be able to handle
> > this problem themselves.
> > 
> > If not, they can use a distro.
> 
> But similarly, people who compile their own kernels are also supposed to
> be able to retrieve up-to-date drivers from another tree. I know many
> people who use the intel NIC drivers from sf.net and (less) other ones
> using myricom's drivers for instance.
> 
> I don't really see the value of keeping in the tree drivers that don't
> work out of the box, if it's only causing issues and bug reports.

Only the firmware is in a separate git tree, called linux-firmware, that
about all kernel developers are aware of.

The drivers themselves are in linux tree, and they are generally in
quite good shape, because of that.



