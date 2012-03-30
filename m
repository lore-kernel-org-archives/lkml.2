Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933789Ab2C3KfD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 06:35:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:44016 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760091Ab2C3Ke5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 06:34:57 -0400
Message-ID: <4F758C06.5060009@kernel.dk>
Date: Fri, 30 Mar 2012 12:33:42 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 01/13] block: use lockdep_assert_held for queue locking
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org> <1332895637-32572-2-git-send-email-andi@firstfloor.org>
In-Reply-To: <1332895637-32572-2-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2012 02:47 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> Instead of an ugly open coded variant.

Thanks Andi, applied. This is definitely an improvement.

-- 
Jens Axboe

