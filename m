Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab1CIJUH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 04:20:07 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:43113 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756880Ab1CIJUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 04:20:03 -0500
Message-ID: <4D774641.3070806@kernel.dk>
Date: Wed, 09 Mar 2011 10:20:01 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, kay.sievers@vrfy.org, hch@infradead.org
Subject: Re: [PATCHSET] block: Convert block drivers to ->check_events(),
 take#2
References: <1299662016-7721-1-git-send-email-tj@kernel.org>
In-Reply-To: <1299662016-7721-1-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-09 10:13, Tejun Heo wrote:
> Hello,
> 
> This is the second take of convert-block-drivers-to-check_events
> patchset.  Other than addition of Acked-by's and rebasing on top of
> the current block:for-2.6.39/core (df457f845e), nothing really
> changed.

Thanks Tejun, applied.

-- 
Jens Axboe

