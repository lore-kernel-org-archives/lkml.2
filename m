Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768664Ab2KOSV1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 13:21:27 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:30341 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768590Ab2KOSVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 13:21:25 -0500
Message-ID: <1353003681.2532.53.camel@lorien2>
Subject: Re: [PATCH RFT RESEND linux-next] mips: dma-mapping: support
 debug_dma_mapping_error
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: m.szyprowski@samsung.com
Cc: ralf@linux-mips.org, kyungmin.park@samsung.com, arnd@arndb.de,
        andrzej.p@samsung.com, linux-mips@linux-mips.org,
        ddaney.cavm@gmail.com, shuahkhan@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 15 Nov 2012 11:21:21 -0700
In-Reply-To: <1351627126.2654.15.camel@lorien2>
References: <1351208193.6851.17.camel@lorien2>
	 <1351267298.4013.12.camel@lorien2> <508ABE1D.5010106@gmail.com>
	 <1351271198.4013.35.camel@lorien2> <508AED66.3040808@gmail.com>
	 <1351288264.6885.11.camel@lorien2> <508B0F4B.80601@gmail.com>
	 <1351627126.2654.15.camel@lorien2>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 13:58 -0600, Shuah Khan wrote:
> On Fri, 2012-10-26 at 15:31 -0700, David Daney wrote:
> > On 10/26/2012 02:51 PM, Shuah Khan wrote:
> > 
> > >>>> On 10/26/2012 09:01 AM, Shuah Khan wrote:
> > >>>>> Add support for debug_dma_mapping_error() call to avoid warning from
> > >>>>> debug_dma_unmap() interface when it checks for mapping error checked
> > >>>>> status. Without this patch, device driver failed to check map error
> > >>>>> warning is generated.
> > 
> > I'm confused.
> > 
> > Your claim that a 'warning is generated' seems to be in conflict with...
> > 
> > 
> > [...]
> > > Got it. Thanks. I would volunteer to look at fixing all the problems,
> > > but unfortunately I don't have a MIPS box handy
> > 
> > This statement that you don't have hardware that exhibits the problem.
> > 
> > How was the patch tested?  How do you even know there is a problem?
> 
> I enhanced the existing dma debug interfaces to add an interface to
> debug missing dma_mapping_error() checks. That went into linux-next.
> With this patch, when dma_map_page() and dma_map_single() are debugged
> with a call to debug_dma_map_page() and the corresponding
> dma_mapping_error() interface doesn't call debug_dma_mapping_error()
> interface, a warning will be generated. I have been sending changes to
> arch specific dma_mapping_error() routines to add this debug interface.
> That is why I marked this patch RFT requesting testing.


Marek,

This one is for mips to go through your tree with the other arch patches
for debug_dma_mapping_error().

Thanks,
-- Shuah

