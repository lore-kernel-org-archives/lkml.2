Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2LFTXf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:23:35 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:36903 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752291Ab2LFTXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:23:34 -0500
X-Greylist: delayed 322 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 14:23:34 EST
Date: Thu, 6 Dec 2012 11:23:28 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, jmoyer@redhat.com
Subject: Re: [PATCH 0/6] cfq-iosched: Some minor cleanups
Message-ID: <20121206192328.GF3676@htj.dyndns.org>
References: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Oct 03, 2012 at 04:56:55PM -0400, Vivek Goyal wrote:
> I posted CFQ changes for changing scheduling algorithm for cfq queues.
> There were few small cleanups/renaming patches. I have pulled out
> these patches from that series and posting these separately. There
> is no functionality change.
> 
> Will post scheduling algorithm changes in a separate series on
> top of this series.
> 
> I have taken care of comments from last posting and also included
> the ACKs.

Nice cleanups.  Jens, except for the last one which changes debug
trace message, all the patches are cosmetic cleanups.  Maybe queueing
them for 3.8 isn't a bad idea?

Thanks.

-- 
tejun
