Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759720Ab1FWQbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 12:31:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33900 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758347Ab1FWQbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 12:31:16 -0400
Message-ID: <4E036A2D.1060402@zytor.com>
Date: Thu, 23 Jun 2011 09:30:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Assmann <sassmann@kpanic.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        tony.luck@intel.com, andi@firstfloor.org, mingo@elte.hu,
        rick@vanrein.org, rdunlap@xenotime.net
Subject: Re: [PATCH v2 0/3] support for broken memory modules (BadRAM)
References: <1308741534-6846-1-git-send-email-sassmann@kpanic.de> <20110623133950.GB28333@srcf.ucam.org> <4E0348E0.7050808@kpanic.de> <20110623141222.GA30003@srcf.ucam.org> <4E035DD1.1030603@kpanic.de>
In-Reply-To: <4E035DD1.1030603@kpanic.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/23/2011 08:37 AM, Stefan Assmann wrote:
> 
> According to Rick's reply in this thread a damaged row in a DIMM can
> easily cause a few thousand entries in the e820 table because it doesn't
> handle patterns. So the question I'm asking is, is it acceptable to
> have an e820 table with thousands maybe ten-thousands of entries?
> I really have no idea of the implications, maybe somebody else can
> comment on that.
> 

Given that that is what actually ends up happening in the kernel at some
point anyway, I don't see why it would matter.

The bubble sort has to go, but quite frankly stress-testing the range
handling isn't a bad thing.
	
	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

