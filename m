Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266Ab2HINUA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 09:20:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:59456 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab2HINT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 09:19:59 -0400
Message-ID: <5023B8E8.60802@kernel.dk>
Date: Thu, 09 Aug 2012 15:19:36 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] bio: Fix potential memory leak in bio_find_or_create_slab()
References: <1344491532-4969-1-git-send-email-khoroshilov@ispras.ru>
In-Reply-To: <1344491532-4969-1-git-send-email-khoroshilov@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 07:52 AM, Alexey Khoroshilov wrote:
> Do not leak memory by updating pointer with potentially NULL realloc return value.
> 
> Found by Linux Driver Verification project (linuxtesting.org).

Thanks, applied.

-- 
Jens Axboe

