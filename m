Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab1GUH1S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 03:27:18 -0400
Received: from [95.166.99.235] ([95.166.99.235]:33754 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751717Ab1GUH1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 03:27:17 -0400
Message-ID: <4E27D4CA.8020900@kernel.dk>
Date: Thu, 21 Jul 2011 09:27:06 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backing-dev: use synchronize_rcu_expedited instead of
  synchronize_rcu
References: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-21 02:29, Mikulas Patocka wrote:
> Hi Jens
> 
> Please would you consider taking this into the block tree? It seems to 
> speed up device deletion enormously.

Sure, looks like a good fix. Reminds me of a similar problem we had in
block core.


-- 
Jens Axboe

