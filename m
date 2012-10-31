Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2JaG4L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 02:56:11 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47156 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752334Ab2JaG4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 02:56:08 -0400
X-AuditID: 9c93016f-b7c7bae000000eb7-e8-5090cb8576c8
Date: Wed, 31 Oct 2012 16:02:02 +0900
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>, gaowanlong@cn.fujitsu.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 0/3] zram/zsmalloc promotion
Message-ID: <20121031070202.GR15767@bbox>
References: <1351501009-15111-1-git-send-email-minchan@kernel.org>
 <20121031010642.GN15767@bbox>
 <20121031014209.GB2672@kroah.com>
 <20121031020443.GP15767@bbox>
 <20121031021618.GA1142@kroah.com>
 <20121031023947.GA24883@bbox>
 <20121031024307.GA9210@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031024307.GA9210@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 07:43:07PM -0700, Greg Kroah-Hartman wrote:
> On Wed, Oct 31, 2012 at 11:39:48AM +0900, Minchan Kim wrote:
> > Greg, what do you think about LTSI?
> > Is it proper feature to add it? For it, still do I need ACK from mm developers?
> 
> It's already in LTSI, as it's in the 3.4 kernel, right?

Right. But as I look, it seems to be based on 3.4.11 which doesn't have
recent bug fix and enhances and current 3.4.16 also doesn't include it.

Just out of curiosity.

Is there any rule about update period in long-term kernel?
I mean how often you release long-term kernel.

Is there any rule about update period in LTSI kernel based on long-term kernel?
If I get the answer on above two quesion, I can expect later what LTSI kernel
version include feature I need.

Another question.
For example, There is A feature in mainline and A has no problem but
someone invents new wheel "B" which is better than A so it replace A totally
in recent mainline. As following stable-kernel rule, it's not a real bug fix
so I guess stable kernel will never replace A with B. It means LTSI never get
a chance to use new wheel. Right?

Thanks.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

-- 
Kind regards,
Minchan Kim
