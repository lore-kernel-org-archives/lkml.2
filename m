Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755366Ab2LFTYb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:24:31 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60962 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353Ab2LFTYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:24:30 -0500
Date: Thu, 6 Dec 2012 11:17:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [PATCH 2/6] cfq-iosched: More renaming to better represent
 wl_class and wl_type
Message-ID: <20121206191706.GA3676@htj.dyndns.org>
References: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
 <1349297821-30078-3-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349297821-30078-3-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:56:57PM -0400, Vivek Goyal wrote:
> Some more renaming. Again making the code uniform w.r.t use of
> wl_class/class to represent IO class (RT, BE, IDLE) and using
> wl_type/type to represent subclass (SYNC, SYNC-IDLE, ASYNC).
> 
> At places this patch shortens the string "workload" to "wl".
> Renamed "saved_workload" to "saved_wl_type". Renamed
> "saved_serving_class" to "saved_wl_class".
> 
> For uniformity with "saved_wl_*" variables, renamed "serving_class"
> to "serving_wl_class" and renamed "serving_type" to "serving_wl_type".
> 
> Again, just trying to improve upon code uniformity and improve
> readability. No functional change.
> 
> v2:
> - Restored the usage of keyword "service" based on Jeff Moyer's feedback.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
