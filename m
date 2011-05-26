Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab1EZTIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 15:08:24 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:51377 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758195Ab1EZTIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 15:08:23 -0400
Message-ID: <4DDEA525.8070200@kernel.dk>
Date: Thu, 26 May 2011 21:08:21 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Luca Tettamanti <kronos.it@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bio_attempt_front_merge: remove unused variable.
References: <20110525204506.GA24207@nb-core2.darkstar.lan>
In-Reply-To: <20110525204506.GA24207@nb-core2.darkstar.lan>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-25 22:45, Luca Tettamanti wrote:
> sector is never read inside the function.

Thanks, applied.

-- 
Jens Axboe

