Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752031Ab0K2JEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 04:04:16 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55345 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751872Ab0K2JEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 04:04:14 -0500
Message-ID: <4CF36C8C.1030506@kernel.dk>
Date: Mon, 29 Nov 2010 10:04:12 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Xiaotian Feng <dfeng@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: check for proper length of iov entries earlier
 in blk_rq_map_user_iov()
References: <1291021255-2838-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <1291021255-2838-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-29 10:00, Xiaotian Feng wrote:
> commit 9284bcf checks for proper length of iov entries in
> blk_rq_map_user_iov(). But if the map is unaligned, kernel
> will break out the loop without checking for the proper length.
> So we need to check the proper length before the unalign check.

Thanks, good catch. Applied.

-- 
Jens Axboe

