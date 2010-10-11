Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab0JKNzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 09:55:47 -0400
Received: from hera.kernel.org ([140.211.167.34]:47397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754211Ab0JKNzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 09:55:46 -0400
Message-ID: <4CB31743.4030705@kernel.org>
Date: Mon, 11 Oct 2010 15:55:15 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Steven Whitehouse <swhiteho@redhat.com>
CC: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Dave Chinner <david@fromorbit.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [PATCH wq#for-next] workqueue: add and use WQ_MEM_RECLAIM flag
References: <4CB30F9A.9030809@kernel.org> <1286805544.2753.102.camel@dolmen>
In-Reply-To: <1286805544.2753.102.camel@dolmen>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 11 Oct 2010 13:55:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/11/2010 03:59 PM, Steven Whitehouse wrote:
> Looks good to me, but we'll need to bear in mind that this patch is
> already queued for the next merge window:
> http://git.kernel.org/?p=linux/kernel/git/steve/gfs2-2.6-nmw.git;a=commitdiff;h=9fa0ea9f26f64fbfc3dfd51d1dc2c230b65ffb19
> 
> so we'll have to figure out how best to merge when the time comes,

It shouldn't be a problem.  As WQ_RESCUER is not removed, it will
continue to work.  We only have to remember to convert it after the
merge.

Thanks.

-- 
tejun
