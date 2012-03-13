Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757275Ab2CMPve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 11:51:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757078Ab2CMPvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 11:51:32 -0400
Date: Tue, 13 Mar 2012 11:51:20 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Shaohua Li <shli@fusionio.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de,
        axboe@kernel.dk, Shaohua Li <shli@fusionio.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [patch 6/7] blk: add plug for blkdev_issue_discard
Message-ID: <20120313155120.GG29169@redhat.com>
References: <20120312030412.375458948@fusionio.com>
 <20120312031305.946211513@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120312031305.946211513@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 12, 2012 at 11:04:18AM +0800, Shaohua Li wrote:
> In raid 0 case, a big discard request is divided into several small requests
> in chunk_size unit. Such requests can be merged in low layer if we have
> correct plug added. This should improve the performance a little bit.

Martin posted a patch to remove the support for allowing merging of discard
requests. But this seems to be a reasonable use case for allowing mering
discard requests. CCing Martin.

Thanks
Vivek
