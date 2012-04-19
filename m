Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab2DSTks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 15:40:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2DSTkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 15:40:47 -0400
Date: Thu, 19 Apr 2012 12:40:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org, Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daniel Walker <dwalker@codeaurora.org>, Mel Gorman <mel@csn.ul.ie>,
        Arnd Bergmann <arnd@arndb.de>, Jesse Barker <jesse.barker@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Chunsang Jeong <chunsang.jeong@linaro.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Rob Clark <rob.clark@linaro.org>, Ohad Ben-Cohen <ohad@wizery.com>,
        Sandeep Patil <psandeep.s@gmail.com>
Subject: Re: [PATCHv24 00/16] Contiguous Memory Allocator
Message-Id: <20120419124044.632bfa49.akpm@linux-foundation.org>
In-Reply-To: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
References: <1333462221-3987-1-git-send-email-m.szyprowski@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Apr 2012 16:10:05 +0200
Marek Szyprowski <m.szyprowski@samsung.com> wrote:

> This is (yet another) update of CMA patches.

Looks OK to me.  It's a lot of code.

Please move it into linux-next, and if all is well, ask Linus to pull
the tree into 3.5-rc1.  Please be sure to cc me on that email.

I suggest that you include additional patches which enable CMA as much
as possible on as many architectures as possible so that it gets
maximum coverage testing in linux-next.  Remove those Kconfig patches
when merging upstream.

All this code will probably mess up my tree, but I'll work that out. 
It would be more awkward if the CMA code were to later disappear from
linux-next or were not merged into 3.5-rc1.  Let's avoid that.
