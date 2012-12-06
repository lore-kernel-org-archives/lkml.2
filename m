Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946931Ab2LFTTP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:19:15 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:46720 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946899Ab2LFTTL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:19:11 -0500
Date: Thu, 6 Dec 2012 11:19:04 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [PATCH 4/6] cfq-iosched: Rename few functions related to
 selecting workload
Message-ID: <20121206191904.GC3676@htj.dyndns.org>
References: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
 <1349297821-30078-5-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349297821-30078-5-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:56:59PM -0400, Vivek Goyal wrote:
> choose_service_tree() selects/sets both wl_class and wl_type.  Rename it to
> choose_wl_class_and_type() to make it very clear.
> 
> cfq_choose_wl() only selects and sets wl_type. It is easy to confuse
> it with choose_st(). So rename it to cfq_choose_wl_type() to make
> it clear what does it do.
> 
> Just renaming. No functionality change.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
