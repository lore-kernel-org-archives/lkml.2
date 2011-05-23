Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1EWIDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 04:03:21 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:47479 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab1EWIDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 04:03:20 -0400
Message-ID: <4DDA14C6.3000409@kernel.dk>
Date: Mon, 23 May 2011 10:03:18 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, dpshah@google.com, namhyung@gmail.com
Subject: Re: [PATCH 0/3] block: Per cpu merge stats and cfq fix
References: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1305936167-8932-1-git-send-email-vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-21 02:02, Vivek Goyal wrote:
> Hi Jens,
> 
> Here is the patch for making merge stats per cpu. While scanning the code
> I also noticed that in one case I was not freeing up per cpu stats. First
> patch fixes it. I also included Namhyung Kim's bio merge fix.

Thanks, looks fine. Merged.

-- 
Jens Axboe

