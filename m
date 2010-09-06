Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab0IFVQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 17:16:51 -0400
Received: from kroah.org ([198.145.64.141]:57506 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755406Ab0IFVQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 17:16:37 -0400
Date: Mon, 6 Sep 2010 14:10:54 -0700
From: Greg KH <greg@kroah.com>
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hans Verkuil <hverkuil@xs4all.nl>, Jonathan Corbet <corbet@lwn.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>, Minchan Kim <minchan.kim@gmail.com>,
        Pawel Osciak <p.osciak@samsung.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Russell King <linux@arm.linux.org.uk>,
        Zach Pfeffer <zpfeffer@codeaurora.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFCv5 8/9] mm: vcm: Sample driver added
Message-ID: <20100906211054.GC5863@kroah.com>
References: <cover.1283749231.git.mina86@mina86.com> <262a5a5019c1f1a44d5793f7e69776e56f27af06.1283749231.git.mina86@mina86.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <262a5a5019c1f1a44d5793f7e69776e56f27af06.1283749231.git.mina86@mina86.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 08:33:58AM +0200, Michal Nazarewicz wrote:
> --- /dev/null
> +++ b/include/linux/vcm-sample.h

Don't put "sample" code in include/linux/ please.  That's just
cluttering up the place, don't you think?  Especially as no one else
needs the file there...

thanks,

greg k-h
