Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab1LPUQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 15:16:18 -0500
Received: from casper.infradead.org ([85.118.1.10]:39934 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932637Ab1LPUQK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 15:16:10 -0500
Message-ID: <4EEBA705.7060900@kernel.dk>
Date: Fri, 16 Dec 2011 21:16:05 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/2]block: recursive merge requests
References: <1324000363.22361.453.camel@sli10-conroe> <20111216193414.GA30654@infradead.org>
In-Reply-To: <20111216193414.GA30654@infradead.org>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-16 20:34, Christoph Hellwig wrote:
> On Fri, Dec 16, 2011 at 09:52:43AM +0800, Shaohua Li wrote:
>> With recursive merge below, the workload throughput gets improved 20%
>> and context switch drops 60%.
> 
> What workload and what filesystem?

It shouldn't really matter for the quoted case, where you have 2
processes issuing interleaved reads.

-- 
Jens Axboe

