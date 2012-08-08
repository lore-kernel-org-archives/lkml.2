Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab2HHGuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:50:18 -0400
Received: from 1wt.eu ([62.212.114.60]:5687 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab2HHGuH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:50:07 -0400
Date: Wed, 8 Aug 2012 08:49:59 +0200
From: Willy Tarreau <w@1wt.eu>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, albcamus@gmail.com, chris@arachsys.com,
        mchan@broadcom.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] bnx2: update bnx2-mips-09 firmware to bnx2-mips-09-6.2.1b
Message-ID: <20120808064959.GB15255@1wt.eu>
References: <20120713130405.GS13885@arachsys.com> <CANE52KgHpmR7qCUUf3ZiMeskCitcAiMzzdARzy3a4RpKb73_Gg@mail.gmail.com> <20120807.225800.1450928472652058111.davem@davemloft.net> <20120808061758.GA15255@1wt.eu> <1344407272.28967.214.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344407272.28967.214.camel@edumazet-glaptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, Aug 08, 2012 at 08:27:52AM +0200, Eric Dumazet wrote:
> On Wed, 2012-08-08 at 08:17 +0200, Willy Tarreau wrote:
> 
> > 
> > Well, if the drivers provided with the kernel don't work out of the box
> > anymore, maybe we should also move them to a separate repository. All it
> > is going to do otherwise is to cause invalid bug reports because users
> > don't understand why using the latest driver does not work.
> > 
> > That way it would be clear that an in-kernel driver has to be self-sustaining
> > to be maintainable, otherwise it has nothing to do there.
> 
> People compiling their own kernels are supposed to be able to handle
> this problem themselves.
> 
> If not, they can use a distro.

But similarly, people who compile their own kernels are also supposed to
be able to retrieve up-to-date drivers from another tree. I know many
people who use the intel NIC drivers from sf.net and (less) other ones
using myricom's drivers for instance.

I don't really see the value of keeping in the tree drivers that don't
work out of the box, if it's only causing issues and bug reports.

Regards,
Willy

