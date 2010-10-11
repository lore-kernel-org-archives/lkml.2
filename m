Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab0JKOAN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 10:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754561Ab0JKOAM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 10:00:12 -0400
Subject: Re: [PATCH wq#for-next] workqueue: add and use WQ_MEM_RECLAIM flag
From: Steven Whitehouse <swhiteho@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>,
        Dave Chinner <david@fromorbit.com>,
        Florian Mickler <florian@mickler.org>
In-Reply-To: <4CB31743.4030705@kernel.org>
References: <4CB30F9A.9030809@kernel.org> <1286805544.2753.102.camel@dolmen>
	 <4CB31743.4030705@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 11 Oct 2010 15:06:05 +0100
Message-ID: <1286805965.2753.103.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2010-10-11 at 15:55 +0200, Tejun Heo wrote:
> Hello,
> 
> On 10/11/2010 03:59 PM, Steven Whitehouse wrote:
> > Looks good to me, but we'll need to bear in mind that this patch is
> > already queued for the next merge window:
> > http://git.kernel.org/?p=linux/kernel/git/steve/gfs2-2.6-nmw.git;a=commitdiff;h=9fa0ea9f26f64fbfc3dfd51d1dc2c230b65ffb19
> > 
> > so we'll have to figure out how best to merge when the time comes,
> 
> It shouldn't be a problem.  As WQ_RESCUER is not removed, it will
> continue to work.  We only have to remember to convert it after the
> merge.
> 
> Thanks.
> 

Ok. I'll make a note to do that. Thanks,

Steve.


