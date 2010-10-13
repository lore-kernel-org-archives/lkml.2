Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0JMUcd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 16:32:33 -0400
Received: from relais.videotron.ca ([24.201.245.36]:12506 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752903Ab0JMUcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 16:32:32 -0400
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_3VSCCemgj8mVS2bR08Yvqg)"
Date: Wed, 13 Oct 2010 16:32:31 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Kevin Cernekee <cernekee@gmail.com>
Cc: Ralf Baechle <ralf@linux-mips.org>, Gary King <gking@nvidia.com>,
        dediao@cisco.com, ddaney@caviumnetworks.com, dvomlehn@cisco.com,
        sshtylyov@mvista.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] MIPS: HIGHMEM DMA on noncoherent MIPS32 processors
In-reply-to: <AANLkTikinkyEu-ozyiHOhr1D4ZLwv0jZwbk=4jq_YM9J@mail.gmail.com>
Message-id: <alpine.LFD.2.00.1010131627220.2764@xanadu.home>
References: <f3f140ca90dc9dac2f645748bc3a0150@localhost>
 <20101013075346.GA24052@linux-mips.org>
 <AANLkTikinkyEu-ozyiHOhr1D4ZLwv0jZwbk=4jq_YM9J@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--Boundary_(ID_3VSCCemgj8mVS2bR08Yvqg)
Content-type: TEXT/PLAIN; charset=UTF-8
Content-transfer-encoding: 8BIT

On Wed, 13 Oct 2010, Kevin Cernekee wrote:

> On Wed, Oct 13, 2010 at 12:53 AM, Ralf Baechle <ralf@linux-mips.org> wrote:
> > It's this disabling of interrupts which I don't like.  It's easy to get
> > around it by having one kmap type for each of process, softirq and
> > interrupt context.
> 
> I am curious as to why ARM opted for the "pte push/pop" strategy
> (kmap_high_l1_vipt()) instead of something along these lines?
> 
> Is there a reason why using 3 kmap types to solve the "interrupted
> flush problem" would work for MIPS, but is not a good solution on ARM?

It would probably be a good solution for ARM as well.


Nicolas

--Boundary_(ID_3VSCCemgj8mVS2bR08Yvqg)--
