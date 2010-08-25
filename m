Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753728Ab0HYR7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 13:59:37 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:53954 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753568Ab0HYR7e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 13:59:34 -0400
Message-ID: <4C755A05.4080604@kernel.dk>
Date: Wed, 25 Aug 2010 19:59:33 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
CC: akpm@linux-foundation.org, mikem@beardog.cce.hp.com,
        linux-kernel@vger.kernel.org, brace@beardog.cce.hp.com
Subject: Re: [PATCH] cciss: fix reporting of max queue depth since init
References: <20100825154334.4941.67993.stgit@beardog.cce.hp.com>
In-Reply-To: <20100825154334.4941.67993.stgit@beardog.cce.hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 05:43 PM, Stephen M. Cameron wrote:
> The ioctl path and the scsi tape path were not accounting
> for their additions to the queue depth.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>

Applied, thanks.

-- 
Jens Axboe

