Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2I1Ih5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:37:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:56463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2I1Ihz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:37:55 -0400
Message-ID: <506561DF.4060807@kernel.dk>
Date: Fri, 28 Sep 2012 10:37:51 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Maxim Levitsky <maximlevitsky@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Alex Dubov <oakad@yahoo.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] scatterlist: refactor the sg_nents
References: <50642ECB.20707@kernel.dk> <1348756117-5299-1-git-send-email-maximlevitsky@gmail.com>
In-Reply-To: <1348756117-5299-1-git-send-email-maximlevitsky@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-27 16:28, Maxim Levitsky wrote:
> Replace 'while' with 'for' as suggested by Tejun Heo

Thanks, purtier :-)

-- 
Jens Axboe

