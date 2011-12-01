Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab1LAQ5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 11:57:09 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44645 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755407Ab1LAQ5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 11:57:07 -0500
Message-ID: <1322758626.30801.5.camel@joe2Laptop>
Subject: Re: linux-next: build failure after merge of the v9fs tree
From: Joe Perches <joe@perches.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Eric Van Hensbergen <ericvh@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Dec 2011 08:57:06 -0800
In-Reply-To: <20111201120215.4320090bef1da653abad3392@canb.auug.org.au>
References: <20111201120215.4320090bef1da653abad3392@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-01 at 12:02 +1100, Stephen Rothwell wrote:
> Hi Eric,
> 
> After merging the v9fs tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> ERROR: "_p9_debug" [net/9p/9pnet_virtio.ko] undefined!
> ERROR: "_p9_debug" [net/9p/9pnet_rdma.ko] undefined!
> ERROR: "_p9_debug" [net/9p/9pnet.ko] undefined!
> 
> Caused by commit be9e4aa9e783 ("9p: Reduce object size with
> CONFIG_NET_9P_DEBUG").
> 
> I have used the v9fs tree from next-20111130 for today.

Thanks Stephen.

Clearly I didn't sufficiently compile test this.
Sorry.  I'll resubmit.


