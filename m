Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab0DHQO0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 12:14:26 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:45907 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754833Ab0DHQOY (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 8 Apr 2010 12:14:24 -0400
Date: Thu, 8 Apr 2010 12:12:10 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Konrad Rzeszutek Wilk <konrad@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yinghai@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Peter Jones <pjones@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [LKML] Re: [PATCH 1/1] ibft, x86: Change reserve_ibft_region()
	to find_ibft_region()
Message-ID: <20100408161210.GA13382@phenom.dumpdata.com>
References: <1270741936-1306-1-git-send-email-konrad@kernel.org> <1270741936-1306-2-git-send-email-konrad@kernel.org> <alpine.LFD.2.00.1004080852200.3558@i5.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004080852200.3558@i5.linux-foundation.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BBE0072.0089:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 08, 2010 at 08:53:48AM -0700, Linus Torvalds wrote:
> 
> 
> On Thu, 8 Apr 2010, Konrad Rzeszutek Wilk wrote:
> >
> > So arch code could decide the way to reserve the ibft.
> > 
> > And We should reserve ibft as early as possible, instead of BOOTMEM stage,
> > in case the table is in RAM range and is not reserved by BIOS.
> 
> For all I know this is all perfectly fine, but I have _no_ idea about how 
> ibft is supposed to work, so I can't really judge it. As a result, I won't 
> pull it without some more acks from people who actually know what that 
> thing is..

Oh, I am definitely ACK-ing. Sorry about not explicitly stating that.
The developer is Yinghai Lu, I am the co-maintainer of the iBFT driver.

Linus, would you like me to modify the commit so that it has 'Acked-by:'
by me in the git tree?
