Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759965Ab2EIP23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:28:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2896 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759928Ab2EIP22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:28:28 -0400
Date: Wed, 9 May 2012 11:27:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "S, Venkatraman" <svenkatr@ti.com>
Cc: Dave Chinner <david@fromorbit.com>, linux-mmc@vger.kernel.org,
        cjb@laptop.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        arnd.bergmann@linaro.org, alex.lemberg@sandisk.com,
        ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH v2 01/16] FS: Added demand paging markers to filesystem
Message-ID: <20120509152758.GB16341@redhat.com>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
 <1336054995-22988-2-git-send-email-svenkatr@ti.com>
 <20120506233117.GU5091@dastard>
 <CANfBPZ_2JeWUu7ti97CVc=ODeEi65ke9EKV6Uje0JHcCM8gYqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANfBPZ_2JeWUu7ti97CVc=ODeEi65ke9EKV6Uje0JHcCM8gYqQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 07, 2012 at 10:16:30PM +0530, S, Venkatraman wrote:

[..]
> This feature doesn't fiddle with the I/O scheduler's ability to balance
> read vs write requests or handling requests from various process queues (CFQ).
> 

Does this feature work with CFQ? As CFQ does not submit sync IO (for
idling queues) while async IO is pending and vice a versa (cfq_may_dispatch()).

Thanks
Vivek
