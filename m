Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab1GWLq1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 07:46:27 -0400
Received: from [95.166.99.235] ([95.166.99.235]:33925 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab1GWLqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 07:46:21 -0400
Message-ID: <4E2AB48C.5070801@kernel.dk>
Date: Sat, 23 Jul 2011 13:46:20 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        stephenmcameron@gmail.com, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, thenzl@redhat.com, stable@kernel.org
Subject: Re: [PATCH] cciss: do not attempt to read from a write-only  register
References: <20110721181601.31646.18252.stgit@beardog.cce.hp.com> <20110722153919.ff53e0ae.akpm@linux-foundation.org>
In-Reply-To: <20110722153919.ff53e0ae.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-23 00:39, Andrew Morton wrote:
> On Thu, 21 Jul 2011 13:16:01 -0500
> "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
> 
>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>
>> Most smartarrays will tolerate it, but some new ones don't.
>> Without this change some newer Smart Arrays will lock up
>> and i/o will grind to a halt.
>>
>> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> No Cc: <stable@kernel.org>?

Patch is already queued up in for-3.1/drivers since July 9th, and I also
marked it stable.

-- 
Jens Axboe

