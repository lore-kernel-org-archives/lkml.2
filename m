Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab1GIHCH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 03:02:07 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:34240 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1GIHCF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 03:02:05 -0400
Message-ID: <4E17FCEB.7000708@kernel.dk>
Date: Sat, 09 Jul 2011 09:02:03 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: stephenmcameron@gmail.com, akpm@linux-foundation.org,
        mikem@beardog.cce.hp.com, linux-kernel@vger.kernel.org,
        thenzl@redhat.com
Subject: Re: [PATCH] cciss: do not attempt to read from a write-only register
References: <20110708195853.3594.38970.stgit@beardog.cce.hp.com>
In-Reply-To: <20110708195853.3594.38970.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-07-08 21:58, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> Most smartarrays will tolerate it, but some new ones don't.

Thanks, I'll queue this for 3.1 and mark for stable backport.

-- 
Jens Axboe

