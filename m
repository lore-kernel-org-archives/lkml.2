Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab2HAK0i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:26:38 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35546 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368Ab2HAK0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:26:37 -0400
Message-ID: <50190456.7010409@kernel.dk>
Date: Wed, 01 Aug 2012 12:26:30 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yuanhan Liu <yuanhan.liu@linux.intel.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove dead func declaration
References: <1341904863-29150-1-git-send-email-yuanhan.liu@linux.intel.com>
In-Reply-To: <1341904863-29150-1-git-send-email-yuanhan.liu@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 09:21 AM, Yuanhan Liu wrote:
> __generic_unplug_device() function is removed with commit
> 7eaceaccab5f40bbfda044629a6298616aeaed50, which forgot to
> remove the declaration at meantime. Here remove it.

Thanks, applied.

-- 
Jens Axboe

