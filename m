Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933928Ab0JSMfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 08:35:21 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:54724 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758235Ab0JSMfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 08:35:20 -0400
Date: Tue, 19 Oct 2010 13:34:41 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Kevin Cernekee <cernekee@gmail.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
Message-ID: <20101019123441.GJ27377@linux-mips.org>
References: <17ebecce124618ddf83ec6fe8e526f93@localhost>
 <17d8d27a2356640a4359f1a7dcbb3b42@localhost>
 <4CBC4F4E.5010305@pobox.com>
 <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com>
 <alpine.LFD.2.00.1010190146360.15889@eddie.linux-mips.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010190146360.15889@eddie.linux-mips.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 01:57:43AM +0100, Maciej W. Rozycki wrote:

>  Ah, the old issue of the write-back barrier.  I can't comment on 
> Loongson, but for DEC IIRC the write-back buffer only needs to be taken 
> care of for uncached writes and they take a path separate to cached 
> writes.  I'd have to dig out the details to be sure.  IIRC the most 
> pathological case was the R2020 WB chip, but that was only used on systems 
> that didn't do DMA (namely DECstatation 3100 and 2100 boxes).

See R4000 User's Manual Version 2, page 326, "Uncached Loads and Stores".
Of course this can only happen on cache coherent or multiprocessor systems.
I guess none of the supported DEC MIPS systems is affected.

  Ralf
