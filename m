Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab2KHMV0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 07:21:26 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:26785 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461Ab2KHMVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 07:21:25 -0500
X-AuditID: cbfee61a-b7fa66d0000004cf-af-509ba3c35fe0
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] DMA: remove unused support for MEMSET operations
Date: Thu, 08 Nov 2012 13:20:19 +0100
User-Agent: KMail/1.13.2 (Linux/3.5.0-rc2+; KDE/4.4.5; i686; ; )
Cc: linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Tomasz Figa <t.figa@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
References: <201211081058.17897.b.zolnierkie@samsung.com>
 <201211081222.05612.b.zolnierkie@samsung.com>
 <20121108113148.36bebd50@pyramind.ukuu.org.uk>
In-reply-to: <20121108113148.36bebd50@pyramind.ukuu.org.uk>
MIME-version: 1.0
Message-id: <201211081320.20215.b.zolnierkie@samsung.com>
Content-type: Text/Plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNLMWRmVeSWpSXmKPExsVy+t9jAd3Di2cHGKydrGhxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyvq3RLDjNXnHv9neWBsbfrF2MnBwSAiYS229PYIOwxSQu3FsP
	ZHNxCAksYpTYsegGM4SzlEli+outLCBVbAJWEhPbVzGC2CIC6hJTV0wH6xYWcJW4+/YrmM0i
	oCrRumMvE4gtKuAg0Tl1AthUZoENjBJ35s1lhZg6i1Hi57ZpYHdwClhLnF3awwxi8woISvyY
	fI8FwraU+PPyIFicWUBLovnNJkYIW15i85q3zBMYgaYgtMxCUjYLSdkCRuZVjKKpBckFxUnp
	uYZ6xYm5xaV56XrJ+bmbGMFB+ExqB+PKBotDjAIcjEo8vBqSswOEWBPLiitzDzFKcDArifBy
	TAAK8aYkVlalFuXHF5XmpBYfYpTmYFES5232SAkQEkhPLEnNTk0tSC2CyTJxcEo1MGa9u9h5
	JPDoo6IM376FVzmk9c2ksueG3FQ43ZFY69/ye2HhvxKX0Kufpddv6FZddPW1dbDBebHify9X
	bxCPtbbYeoeJ1UZO6c+jzvoWhVnHNk9VVV5xdaqm09c1Ty+uWJ/hnWUlXuZvfNz7y6fVl472
	3audvLvz2Gf/o0aWD8V92RJqGr4qpymxFGckGmoxFxUnAgAGZwdLPgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 08 November 2012 12:31:48 Alan Cox wrote:
> On Thu, 08 Nov 2012 12:22:05 +0100
> Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> 
> > On Thursday 08 November 2012 12:12:31 Alan Cox wrote:
> > > On Thu, 08 Nov 2012 10:58:17 +0100
> > > Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com> wrote:
> > > 
> > > > From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > > > Subject: [PATCH] DMA: remove unused support for MEMSET operations
> > > > 
> > > > There have never been any real users of MEMSET operations
> > > 
> > > In tree users.
> > 
> > Please show me them. 
> 
> Sorry ? There are potentially lots of out of tree users in both the ARM
> and x86 communities.

They had almost six years to submit their code to upstream and there is
potentially no problem for these _out_of_tree_ users to maintain also
memset code out of tree.  

Best regards,
--
Bartlomiej Zolnierkiewicz
Samsung Poland R&D Center
