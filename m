Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933091Ab0GOPxc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 11:53:32 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:44790 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932412Ab0GOPxb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 11:53:31 -0400
Message-ID: <4C3F2EF4.6020203@kernel.dk>
Date: Thu, 15 Jul 2010 09:53:24 -0600
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Christof Schmitt <christof.schmitt@de.ibm.com>
CC: "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] block: Apply segment size and boundary limits to
 integrity data
References: <20100715153410.774329000@de.ibm.com> <20100715154547.485829000@de.ibm.com>
In-Reply-To: <20100715154547.485829000@de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2010 09:34 AM, Christof Schmitt wrote:
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> Apply the conditions used in __blk_recalc_rq_segments also to
> integrity data: Adhere to the maximum segment size and the segment
> boundary set by the driver. Without this change, a driver would
> receive integrity data blocks that do not adhere to the limits set for
> the request queue.

Thanks. The level of duplication there is nasty, particularly for such
intricate code as this that has had bugs in the past in the core.

-- 
Jens Axboe

