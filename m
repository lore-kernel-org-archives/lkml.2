Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946961Ab2LFT2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:28:19 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:65505 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1424699Ab2LFT2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:28:17 -0500
Date: Thu, 6 Dec 2012 11:21:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [PATCH 6/6] cfq-iosched: Print sync-noidle information in
 blktrace messages
Message-ID: <20121206192135.GE3676@htj.dyndns.org>
References: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
 <1349297821-30078-7-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349297821-30078-7-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:57:01PM -0400, Vivek Goyal wrote:
> Currently we attach a character "S" or "A" to the cfqq<pid>, to represent
> whether queues is sync or async. Add one more character "N" to represent
> whether it is sync-noidle queue or sync queue. So now three different
> type of queues will look as follows.
> 
> cfq1234S   --> sync queus
> cfq1234SN  --> sync noidle queue
> cfq1234A   --> Async queue
> 
> Previously S/A classification was being printed only if group scheduling
> was enabled. This patch also makes sure that this classification is
> displayed even if group idling is disabled.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
