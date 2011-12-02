Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab1LBMrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 07:47:25 -0500
Received: from casper.infradead.org ([85.118.1.10]:58618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab1LBMrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 07:47:24 -0500
Message-ID: <4ED8C8D2.5040203@axboe.dk>
Date: Fri, 02 Dec 2011 13:47:14 +0100
From: Jens Axboe <jens@axboe.dk>
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Greg KH <greg@kroah.com>, lttng-dev@lists.lttng.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH] fs/splice: export splice_to_pipe to modules
References: <20111202124352.GB13082@Krystal>
In-Reply-To: <20111202124352.GB13082@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-02 13:43, Mathieu Desnoyers wrote:
> The LTTng driver needs this symbol exported because it implements its
> own splice actor.
> 
> All other exports in splice are EXPORT_SYMBOL(), so follow the local
> trend by not using a _GPL() export.

Thanks, that makes more sense to me.

Acked-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

