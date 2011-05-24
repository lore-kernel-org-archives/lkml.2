Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754444Ab1EXIOA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:14:00 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:59300 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab1EXIN7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:13:59 -0400
Message-ID: <4DDB68C5.4060708@kernel.dk>
Date: Tue, 24 May 2011 10:13:57 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] cfq-iosched: algebraic simplification in cfq_prio_to_maxrq()
References: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
In-Reply-To: <1306207131-2296-1-git-send-email-namhyung@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-24 05:18, Namhyung Kim wrote:
> Simplify the calculation in cfq_prio_to_maxrq(), plus replace CFQ_PRIO_LISTS to
> IOPRIO_BE_NR since they are the same and IOPRIO_BE_NR looks more reasonable in
> this context IMHO.

Double checked your math, it is indeed identical to
2*base_rq*IOPRIO_BE_NR - 2*base_rq*cfqq->ioprio. Looks a lot cleaner,
thanks.

-- 
Jens Axboe

