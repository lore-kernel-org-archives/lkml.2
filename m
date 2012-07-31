Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab2GaPqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 11:46:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:54915 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2GaPqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 11:46:31 -0400
Message-ID: <5017FDCE.5030700@kernel.dk>
Date: Tue, 31 Jul 2012 17:46:22 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: merez@codeaurora.org
CC: linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        DOCUMENTATION <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 1/3] block: Add test-iosched scheduler
References: <n> <1343744710-31700-2-git-send-email-merez@codeaurora.org> <09c3a301ad7ca4fa396c4d00615312c1.squirrel@www.codeaurora.org>
In-Reply-To: <09c3a301ad7ca4fa396c4d00615312c1.squirrel@www.codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 04:36 PM, merez@codeaurora.org wrote:
> Hi Jens,
> 
> Do you have comments on this patch?
> Can we push it to kernel 3.6 version?

I have questions - what is this good for? In other words, explain to me
why this is useful code. And in particular why this cannot be done from
userspace with bsg and block tracing?

IOW, I'm dubious as to whether a new _io scheduler_ is the correct
solution to the problem you have at hand.

-- 
Jens Axboe

