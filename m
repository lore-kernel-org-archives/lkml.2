Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754619Ab0GELRi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 07:17:38 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:37495 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752965Ab0GELRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 07:17:35 -0400
Message-ID: <4C31BF4C.7060205@kernel.dk>
Date: Mon, 05 Jul 2010 13:17:32 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove unused REQ_TYPE_LINUX_BLOCK
References: <20100705181100B.fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100705181100B.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-07-05 11:11, FUJITA Tomonori wrote:
> You prefer to keep this for future possible users?

No, lets just kill it if there are no users left. We can
always resurrect something like this later, if we want to.

-- 
Jens Axboe

