Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946899Ab2LFTZk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 14:25:40 -0500
Received: from mail-ia0-f170.google.com ([209.85.210.170]:61664 "EHLO
	mail-ia0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423240Ab2LFTZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 14:25:37 -0500
X-Greylist: delayed 503 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Dec 2012 14:25:37 EST
Date: Thu, 6 Dec 2012 11:18:07 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com
Subject: Re: [PATCH 3/6] cfq-iosched: Rename "service_tree" to "st" at some
 places
Message-ID: <20121206191807.GB3676@htj.dyndns.org>
References: <1349297821-30078-1-git-send-email-vgoyal@redhat.com>
 <1349297821-30078-4-git-send-email-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349297821-30078-4-git-send-email-vgoyal@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 03, 2012 at 04:56:58PM -0400, Vivek Goyal wrote:
> At quite a few places we use the keyword "service_tree". At some places,
> especially local variables, I have abbreviated it to "st".
> 
> Also at couple of places moved binary operator "+" from beginning of line
> to end of previous line, as per Tejun's feedback.
> 
> v2:
>  Reverted most of the service tree name change based on Jeff Moyer's feedback.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Acked-by: Tejun Heo <tj@kernel.org>

-- 
tejun
