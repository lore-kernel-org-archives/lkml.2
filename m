Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752284Ab2FSKUB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 06:20:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab2FSKTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 06:19:45 -0400
Date: Tue, 19 Jun 2012 12:19:28 +0200
From: Karel Zak <kzak@redhat.com>
To: Zheng Liu <gnehzuil.liu@gmail.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        util-linux@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Rob Landley <rob@landley.net>,
        Bernhard Voelker <mail@bernhard-voelker.de>,
        Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [PATCH] docs: block: update ioprio.txt
Message-ID: <20120619101928.GD13108@x2.net.home>
References: <1340095897-9014-1-git-send-email-wenqing.lz@taobao.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340095897-9014-1-git-send-email-wenqing.lz@taobao.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2012 at 04:51:37PM +0800, Zheng Liu wrote:
> From: Zheng Liu <wenqing.lz@taobao.com>
> 
> The ionice.c in ioprio.txt document needed updating for the latest util-linux
> version.
> 
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Rob Landley <rob@landley.net>
> CC: Bernhard Voelker <mail@bernhard-voelker.de>
> Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
> ---
>  Documentation/block/ioprio.txt |  174 +++++++++++++++++++++++++---------------
>  1 files changed, 109 insertions(+), 65 deletions(-)

 BTW, does it make sense to maintain duplicate, untested and unused
 code in kernel docs if we already have regular ionice(1) implementation
 in util-linux?

 Would be better to add URL to *maintained* code?
 http://git.kernel.org/?p=utils/util-linux/util-linux.git;a=blob_plain;f=schedutils/ionice.c;hb=HEAD

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
