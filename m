Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290Ab0GVG5V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 02:57:21 -0400
Received: from smtp.nokia.com ([192.100.122.230]:48106 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab0GVG5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 02:57:20 -0400
Subject: Re: [PATCHv2 11/11] writeback: prevent unnecessary bdi threads
 wakeups
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20100722004155.GZ32635@dastard>
References: <1279704706-1267-1-git-send-email-dedekind1@gmail.com>
	 <1279704706-1267-12-git-send-email-dedekind1@gmail.com>
	 <1279712741.2306.36.camel@localhost>  <20100722004155.GZ32635@dastard>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 22 Jul 2010 09:50:11 +0300
Message-ID: <1279781411.3044.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-1.fc13) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 22 Jul 2010 06:56:57.0046 (UTC) FILETIME=[1331C760:01CB296B]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-07-22 at 10:41 +1000, Dave Chinner wrote:
> 	if (wakeup_bdi) {
> 		trace_writeback_wakeup(bdi)
> 		spin_lock(&bdi->wb_lock);
> 		if (!bdi->wb.task) {{
> 			trace_writeback_wakeup_nothread(bdi);
> 			wake_up_process(default_backing_dev_info.wb.task);
> 		} else
> 			wake_up_process(bdi->wb.task);
> 		spin_unlock(&bdi->wb_lock);
> 	}

OK, I'll take a look at this and will try to add this to v3, thanks.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

