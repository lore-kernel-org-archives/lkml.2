Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753288Ab2ILUZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:25:40 -0400
Received: from [205.233.59.134] ([205.233.59.134]:53305 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753217Ab2ILUZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:25:35 -0400
Message-ID: <5050EF90.2090802@kernel.dk>
Date: Wed, 12 Sep 2012 22:24:48 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/9] block/blk-tag.c: Remove useless kfree
References: <1347462407-13499-2-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1347462407-13499-2-git-send-email-peter.senna@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-09-12 17:06, Peter Senna Tschudin wrote:
> From: Peter Senna Tschudin <peter.senna@gmail.com>
> 
> Remove useless kfree() and clean up code related to the removal.

Thanks, nice cleanup! Applied to for-3.7/core

-- 
Jens Axboe

