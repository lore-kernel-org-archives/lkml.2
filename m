Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1LSJsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 04:48:13 -0500
Received: from merlin.infradead.org ([205.233.59.134]:45734 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063Ab1LSJsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 04:48:10 -0500
Message-ID: <4EEF0856.3040306@kernel.dk>
Date: Mon, 19 Dec 2011 10:48:06 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the block tree
References: <20111219141929.e27fd6b6ac0b9f6ae33f89c7@canb.auug.org.au> <CA+icZUWrpTFPhM0cTQgvBPnMqT3zZufcxQ6c6wh7=EtkD4of9w@mail.gmail.com>
In-Reply-To: <CA+icZUWrpTFPhM0cTQgvBPnMqT3zZufcxQ6c6wh7=EtkD4of9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-19 10:45, Sedat Dilek wrote:
> Just FYI:
> 
> - block           git     git://git.kernel.dk/linux-2.6-block.git#for-next
> + block           git     git://git.kernel.dk/linux-block.git#for-next

linux-block.git is the one that should be used, however the 2.6 one is
just a link to the new one. So old urls work just fine as well, it all
goes to the same spot.

-- 
Jens Axboe

