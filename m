Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995Ab0GYJIq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 05:08:46 -0400
Received: from smtp.nokia.com ([192.100.105.134]:37454 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab0GYJIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 05:08:44 -0400
Subject: Re: [PATCHv5 00/15] kill unnecessary bdi wakeups + cleanups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
References: <1280046581-23623-1-git-send-email-dedekind1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 25 Jul 2010 12:01:18 +0300
Message-ID: <1280048478.9990.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 Jul 2010 09:08:39.0006 (UTC) FILETIME=[F85E6FE0:01CB2BD8]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-07-25 at 11:29 +0300, Artem Bityutskiy wrote:
> Changes since v4
> Most patches are intact. Only patches N9, N10 and N14 were changed. And patch
> N15 was added. Also, now I tested the patch-set much better.
> 
> 1. Fix a bug found while testing: in the forker thread, when we create a bdi
>    task and then assign it to 'bdi->wb.task', we need to take the
>    'bdi->work_lock'. Otherwise we can lose a wake-up. Changed this in patch
>    N10.
> 2. Add patch 15 which fixes a warning and cleans up 'bdi_register()'.
> 3. Use "switch" in the main forker thread loop. Patch N9 was changed and now it
>    also introduces the "switch".
> 4. Stick with Christoph's version of tracepoint names and positions -> changed
>    patch N14.
> 5. Add a couple of "Reviewed-by" tags.

Oh, completely forgot to mention another thing.

6. Addressed the issue pointed to by Christoph and added
  'del_timer_sync()'

So patch N12 was also tweaked.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

