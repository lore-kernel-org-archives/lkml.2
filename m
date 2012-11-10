Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751126Ab2KJJma (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 04:42:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37415 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab2KJJm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 04:42:29 -0500
Message-ID: <509E2182.5090505@kernel.dk>
Date: Sat, 10 Nov 2012 10:42:26 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Ezequiel Garcia <elezegarcia@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: Use NUMA_NO_NODE instead of -1
References: <1352475464-11951-1-git-send-email-elezegarcia@gmail.com> <509E20A1.5040309@kernel.dk>
In-Reply-To: <509E20A1.5040309@kernel.dk>
X-Enigmail-Version: 1.4.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-11-10 10:38, Jens Axboe wrote:
> On 2012-11-09 16:37, Ezequiel Garcia wrote:
>> Cc: Jens Axboe <axboe@kernel.dk>
>> Signed-off-by: Ezequiel Garcia <elezegarcia@gmail.com>
> 
> Thanks, applied.

BTW, you missed blk_init_queue(), I fixed up that one too.

-- 
Jens Axboe

